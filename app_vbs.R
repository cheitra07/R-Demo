library(shiny)
library(forecast)
library(ggplot2)

ui <- fluidPage(
  tags$head(
    includeScript("www/d3.min.js"),
    tags$script(src = "https://cdnjs.cloudflare.com/ajax/libs/Chart.js/4.4.1/chart.min.js"),
    includeScript("www/custom.js")
  ),
  titlePanel("Sales Escalation Analysis"),
  sidebarLayout(
    sidebarPanel(),
    mainPanel(
      plotOutput("timeSeriesPlot"),
      tags$div(id = "d3Chart"),  # Placeholder for D3.js chart
      tags$canvas(id = "chartjsCanvas", width = "400", height = "200")  # Chart.js chart
    )
  )
)

server <- function(input, output, session) {
  # Call VBScript when app is started
  observe({
    tryCatch({
      # Correct path to your .vbs file
      result <- system('cscript "D:/2024-D/Interview Prep 2024/Rshiny-remote-role/R-Demo/sales-escalation/vbscript.vbs"', intern = TRUE)
      
      output$message <- renderText({
        paste("VBScript executed successfully. Output:", paste(result, collapse = "\n"))
      })
    }, error = function(e) {
      output$message <- renderText({
        paste("Error executing VBScript:", e$message)
      })
    })
  })
  # Reactive data processing
  forecast_data <- reactive({
    sales_data <- read.csv("data/sales_data.csv")
    sales_data$Invoice_Date <- as.Date(sales_data$Invoice_Date)
    monthly_sales <- aggregate(Invoice_Price ~ format(Invoice_Date, "%Y-%m"), 
                               data = sales_data, FUN = mean)
    colnames(monthly_sales) <- c("Month", "Avg_Price")
    ts_data <- ts(monthly_sales$Avg_Price, start = c(2023, 1), frequency = 12)
    forecast_model <- auto.arima(ts_data)
    forecast(forecast_model, h = 6)
  })
  
  # Output plot
  output$timeSeriesPlot <- renderPlot({
    plot(forecast_data(), main = "Price Escalation Forecast", col = "blue")
  })
}

shinyApp(ui = ui, server = server)
