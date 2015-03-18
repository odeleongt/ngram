
shinyUI(
  bootstrapPage(
    includeCSS("./includes/awesomplete/awesomplete.css"),
    includeScript("./includes/awesomplete/awesomplete.js"),
    includeScript("./includes/remove-branding.js"),
    div(style="width:100%;height:50px;background:#216699;",
        span(style=paste0("font-family:\"Open Sans\",\"Helvetica Neue\",",
                          "Arial,sans-serif;font-size:24px;color:#FFF;",
                          "display:inline-block;line-height:50px;"),
             class="pull-left", "n-gram predictor"),
        div(class="pull-right", style="width:50px",
            tags$object(data="example.svg", type="image/svg+xml",
                        img(src="./img/repo_logo.svg", alt="n-gram",
                            width="50px", height="50px")))),
    fluidRow(
      column(
        width = 4,
        div(class="form-group shiny-input-container",
            div(tags$label("Autocomplete")),
            tags$input(id="text", type="text",
                       class="awesomplete form-control",
                       style="width:17em;",
                       value="", autofocus="true", 'data-multiple'="true",
                       'data-minchars'="1" , 'data-autofirst'="true",
                       'data-list'= paste(scan(file = "./data/common-english-words",
                                               what = "character"), collapse = " "))
        )),
      column(
        width = 4,
        textOutput('text')))
  )
)
