
shinyServer(
  function(input, output) {
    output$text <- renderText({ paste0("Input text: {", input$text, "}") })
  }
)
