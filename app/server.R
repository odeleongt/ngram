updateInput <- function(input, session, prediction) {
  updateTextInput(session, "text", value = paste(input$text, prediction))
}

get_prediction <- function(sentence,  i=1) {
  list(words = sample(c("the", "to", "and", "a", "I", "of", "in", "it", "that", "for")))
}

shinyServer(
  function(input, output, session) {
    output$text <- renderText({ paste0("{", input$text, "}") })
    
    values <- reactiveValues()
    values$predictions  <- get_prediction("")$words
    
    #*-------------------------------------------------------------------------*
    # Add observe block for each button
    #*-------------------------------------------------------------------------*
    
    # Prediction 1
    observe({
      if(input$pred1 == 0) return()
      isolate({
        updateTextInput(session, "text",
                        value = paste(input$text, values$predictions[1]))
      })
    })
    
    # Prediction 2
    observe({
      if(input$pred2 == 0) return()
      isolate({
        updateTextInput(session, "text",
                        value = paste(input$text, values$predictions[2]))
      })
    })
    
    # Prediction 3
    observe({
      if(input$pred3 == 0) return()
      isolate({
        updateTextInput(session, "text",
                        value = paste(input$text, values$predictions[3]))
      })
    })
    
    observe({
      text <- input$text
      prediction <- get_prediction(text)
      isolate(values$predictions  <- prediction$words)
    })
    
    
    #*-------------------------------------------------------------------------*
    # Add render text for each button
    #*-------------------------------------------------------------------------*
    
    # Prediction 1
    output$pred1_label <- renderText({
      values$predictions[1]
    })
    
    # Prediction 2
    output$pred2_label <- renderText({
      values$predictions[1]
    })
    
    # Prediction 3
    output$pred3_label <- renderText({
      values$predictions[1]
    })
  }
)
