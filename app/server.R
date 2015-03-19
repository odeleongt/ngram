
shinyServer(
  function(input, output) {
    output$text <- renderText({ input$text })
  }
)
