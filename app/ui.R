
shinyUI(
  bootstrapPage(
    numericInput('n', 'Number of obs', 100),
    plotOutput('plot')
  )
)
