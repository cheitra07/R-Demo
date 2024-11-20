Shiny.addCustomMessageHandler("updateChart", function(data) {
    var ctx = document.getElementById('chartCanvas').getContext('2d');
    new Chart(ctx, {
        type: 'line',
        data: {
            labels: [...Array(data.labels.length).keys()],
            datasets: [{
                label: 'Forecast',
                data: data.labels,
                borderColor: 'rgba(75, 192, 192, 1)',
                borderWidth: 2
            }]
        }
    });
});
// D3.js example chart
d3.select("#d3Chart")
  .append("svg")
  .attr("width", 500)
  .attr("height", 300)
  .append("circle")
  .attr("cx", 150)
  .attr("cy", 150)
  .attr("r", 50)
  .attr("fill", "blue");
// Chart.js example chart
const ctx = document.getElementById('chartjsCanvas').getContext('2d');
new Chart(ctx, {
    type: 'line',
    data: {
        labels: ['Jan', 'Feb', 'Mar', 'Apr'],
        datasets: [{
            label: 'Price Escalation',
            data: [450, 470, 490, 510],
            borderColor: 'rgba(75, 192, 192, 1)',
            borderWidth: 2
        }]
    },
    options: {
        responsive: true
    }
});

$(document).ready(function() {
  // Example: Changing the background color of a div when the document is ready
  $("#d3Chart").css("background-color", "#f0f0f0");
});

