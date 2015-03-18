
shinyUI(
  bootstrapPage(
    includeCSS("./includes/awesomplete/awesomplete.css"),
    includeScript("./includes/awesomplete/awesomplete.js"),
    fluidRow(
      column(
        width = 6,
        div(class="form-group shiny-input-container",
            tags$label("Autocomplete"),
            tags$input(id="text", type="text", class="awesomplete form-control",
                       style="width:25em;",
                       value="", autofocus="true", 'data-multiple'="true",
                       'data-minchars'="1" , 'data-autofirst'="true",
                       'data-list'= paste(scan(file = "./data/common-english-words",
                                               what = "character"), collapse = " "))
        )),
      column(width = 6, textOutput('text')))
  )
)
