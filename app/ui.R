#------------------------------------------------------------------------------*
# Prepare environment
#------------------------------------------------------------------------------*

# Load used packages
library(package = markdown)




#------------------------------------------------------------------------------*
# Setup app
#------------------------------------------------------------------------------*

shinyUI(
  bootstrapPage(
    includeCSS("./includes/maciej-text-width.css"),
    includeCSS("./includes/awesomplete/awesomplete.css"),
    includeScript("./includes/awesomplete/awesomplete.js"),
    includeScript("./includes/remove-branding.js"),
  fixedPage(
    div(style="width:100%;min-height:50px;background:#216699;overflow:overlay;",
        span(style=paste0("font-family:\"Open Sans\",\"Helvetica Neue\",",
                          "Arial,sans-serif;font-size:24px;color:#FFF;",
                          "display:inline-block;line-height:50px;"),
             class="pull-left", "n-gram predictor"),
        div(class="pull-right", style="width:50px",
            tags$object(data="example.svg", type="image/svg+xml",
                        img(onload="clear_branding()",
                            src="./img/repo_logo.svg", alt="n-gram",
                            width="50px", height="50px")))),
    tabsetPanel(
      selected = "App",
      tabPanel(
        title = "Instructions",
        includeMarkdown("./content/instructions.md")),
      tabPanel(id = "app",
        title = "App",
        includeMarkdown(path = "./content/app.md"),
        fluidRow(
          column(
            width = 6,
            div(class="form-group shiny-input-container",
                tags$input(id="text", type="text",
                           class="awesomplete form-control",
                           value="", autofocus="true", 'data-multiple'="true",
                           'data-minchars'="1" , 'data-autofirst'="true",
                           'data-list'= paste(scan(file = "./data/common-english-words",
                                                   what = "character"), collapse = " "))
            )),
          column(
            width = 6,
            wellPanel(
              div(tags$label("Input text")),
              textOutput('text'))))),
      tabPanel(
        title = "About the model",
        includeMarkdown(path = "./content/about_model.md")),
      tabPanel(
        title = "Components",
        includeMarkdown(path = "./content/components.md")),
      tabPanel(
        title = "Collaborating",
        includeMarkdown(path = "./content/collaborating.md")),
      tabPanel(
        title = "About the author",
        includeMarkdown(path = "./content/about_author.md"))
    )
  ))
)
