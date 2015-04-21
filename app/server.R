updateInput <- function(input, session, prediction) {
  updateTextInput(session = session, inputId = "text",
                  value = paste0(input$text, " ", prediction, " "))
}

get_prediction <- function(sentence,  i=1) {
  list(words = sample(c("the", "to", "and", "a", "I", "of", "in", "it", "that", "for")))
}

# Source helper functions
source(file = "./R/clean_text.R")

shinyServer(
  function(input, output, session) {
    #*-------------------------------------------------------------------------*
    # Set list for reactive values
    #*-------------------------------------------------------------------------*
    
    values <- reactiveValues()
    values$predict <- FALSE
    values$predictions  <- get_prediction("")$words
    
    
    #*-------------------------------------------------------------------------*
    # Predict when the input text ends in space(s)
    #*-------------------------------------------------------------------------*
    
    observe({
      if(grepl("[[:space:]]+$", input$text)){
        values$predict <- TRUE
      }
    })
    
    
    #*-------------------------------------------------------------------------*
    # Add observe block for each button
    #*-------------------------------------------------------------------------*
    
    # Prediction 1
    observe({
      if(input$pred1 == 0) return()
      isolate({
        updateInput(input, session, values$predictions[1])
      })
      values$predict <- FALSE
    })
    
    # Prediction 2
    observe({
      if(input$pred2 == 0) return()
      isolate({
        updateInput(input, session, values$predictions[2])
      })
      values$predict <- FALSE
    })
    
    # Prediction 3
    observe({
      if(input$pred3 == 0) return()
      isolate({
        updateInput(input, session, values$predictions[3])
      })
      values$predict <- FALSE
    })
    
    

        
    
    #*-------------------------------------------------------------------------*
    # Predict
    #*-------------------------------------------------------------------------*
    observe({
      if(values$predict){
        # Perform all predictions in an isolated environment
        # (only triggered on values$predict)
        isolate({
          # Clean and tokenize
          values$text <- clean_text(input$text)
          values$tokens <- unlist(strsplit(x = values$text, split = "[[:space:]]+"))
          
          # Predict
          prediction <- get_prediction(values$tokens)
          isolate(values$predictions  <- prediction$words)
          
          # Toggle prediction
          values$predict <- FALSE
          updateTextInput(session, "text",
                          value = gsub("[[:space:]]+$", "", input$text))
        })
      }
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
      values$predictions[2]
    })
    
    # Prediction 3
    output$pred3_label <- renderText({
      values$predictions[3]
    })
    
    
    
    #*-------------------------------------------------------------------------*
    # Update output
    #*-------------------------------------------------------------------------*
    
    output$text <- renderText({ paste0("{", values$text, "}") })
  }
)
