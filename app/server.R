
shinyServer(
  function(input, output) {
    output$text <- renderText({ paste0("{", input$text, "}") })
  }
)
