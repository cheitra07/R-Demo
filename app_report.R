library(shiny)
library(plotly)
library(dplyr)
library(rmarkdown)

# Sample data
sales_data <- data.frame(
  date = seq.Date(from = as.Date("2024-01-01"), by = "month", length.out = 25),
  sales = c(100, 110, 115, 120, 125, 130, 125, 135, 140, 145, 150, 155, 160, 165, 170, 
            180, 175, 185, 190, 195, 200, 210, 220, 215, 230)
)

# Define UI
ui <- fluidPage(
  titlePanel("Sales Escalation Analysis"),
  sidebarLayout(
    sidebarPanel(
      selectInput("time_period", "Select Time Period", 
                  choices = c("1 Month", "3 Months", "6 Months"), 
                  selected = "1 Month"),
      downloadButton("download_report", "Download Report")  # Add download button
    ),
    mainPanel(
      plotlyOutput("sales_plot")  # Render Plotly chart
    )
  )
)

# Define server logic
server <- function(input, output, session) {
  
  # Reactive expression to filter data based on selected time period
  filtered_data <- reactive({
    req(input$time_period)  # Ensure input is available
    
    # Filter data based on time period
    if (input$time_period == "1 Month") {
      return(sales_data %>% filter(date >= Sys.Date() - 30))
    } else if (input$time_period == "3 Months") {
      return(sales_data %>% filter(date >= Sys.Date() - 90))
    } else {
      return(sales_data)
    }
  })
  
  # Render Plotly chart
  output$sales_plot <- renderPlotly({
    data <- filtered_data()  # Get filtered data
    
    # Create an empty plotly plot
    plot <- plot_ly()
    
    # Loop through the data and add line segments with color based on increase or decrease
    for (i in 2:nrow(data)) {
      color <- ifelse(data$sales[i] > data$sales[i - 1], "green", "red")
      plot <- plot %>% add_trace(
        x = data$date[c(i-1, i)], 
        y = data$sales[c(i-1, i)], 
        type = 'scatter', 
        mode = 'lines+markers', 
        line = list(color = color), 
        hoverinfo = 'text', 
        text = as.character(paste('Sales: ', data$sales[c(i-1, i)]))  # Corrected hover text
      )
    }
    
    # Customize the plot layout
    plot %>%
      layout(
        title = 'Sales Escalation',
        xaxis = list(title = 'Date'),
        yaxis = list(title = 'Sales')
      )
  })
  
  # Render the download handler for the report
  output$download_report <- downloadHandler(
    filename = function() {
      paste("sales_report_", Sys.Date(), ".html", sep = "")
    },
    content = function(file) {
      # Render the RMarkdown file into an HTML document
      rmarkdown::render("report.Rmd", output_file = file)  # Ensure the path to your .Rmd file is correct
    }
  )
}

# Run the application
shinyApp(ui = ui, server = server)
