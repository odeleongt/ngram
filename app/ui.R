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
    includeCSS("./includes/custom-styles.css"),
    includeCSS("./includes/maciej-text-width.css"),
    includeCSS("./includes/awesomplete/awesomplete.css"),
    includeScript("./includes/awesomplete/awesomplete.js"),
    includeScript("./includes/remove-branding.js"),
    includeScript("./includes/keypress.js"),
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
        title = "Information",
        tabsetPanel(
          selected = "Instructions",
          tabPanel(
            title = "Instructions",
            includeMarkdown("./content/instructions.md")),
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
            includeMarkdown(path = "./content/about_author.md")),
          tabPanel(
            title = "Acknowledgments",
            includeMarkdown(path = "./content/acknowledgments.md"))
      )),
      tabPanel(id = "app",
        title = "App",
        includeMarkdown(path = "./content/app.md"),
        column(
          width = 8,
          fixedRow(
            column(
              width = 6,
              actionButton(inputId = "pred2",  label = textOutput("pred2_label"),
                           icon = span(class="badge", 2, style = "float:left;"),
                           style = "float:left;")
            ),
            column(
              width = 6,
              actionButton(inputId = "pred3",  label = textOutput("pred3_label"),
                           icon = span(class="badge", 3, style = "float:left;"),
                           style = "float:left;")
            ),
            column(
              width = 12,
              actionButton(inputId = "pred1",  label = textOutput("pred1_label"),
                           icon = span(class="badge", 1, style = "float:left;"),
                           style = "font-weight: bolder; float:left; background: #FFCCCC;")
            )
          ),
          fluidRow(
            column(
              width = 12,
              div(class="form-group shiny-input-container",
                  tags$input(
                    id="text", type="text",
                    class="awesomplete form-control",
                    value="", autofocus="true", 'data-multiple'="true",
                    'data-minchars'="1" , 'data-autofirst'="true",
                    'data-list'= paste(scan(file = "./data/common-english-words",
                                            what = "character"), collapse = " "))
              ))),
          fixedRow(
            column(
              width = 6,
              actionButton(inputId = "clear", label = "Clear input")
            ),
            column(
              width = 6,
              actionButton(inputId = "random", label = "Random options")
            )
          )),
        column(
          width = 4,
          wellPanel(
            div(tags$label("Input text")),
            textOutput('text'))))
    )
  ))
)
