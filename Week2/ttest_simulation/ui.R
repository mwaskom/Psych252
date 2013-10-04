library(shiny)

fig.width <- 600
fig.height <- 350
shinyUI(pageWithSidebar(
  headerPanel("Simulating T-Tests"),
  
  sidebarPanel(
    sliderInput("true.mean", 
                strong("True population mean"), 
                min=0, max=1, value=0, step=.1, ticks=FALSE),
    sliderInput("true.sd",
                strong("True population standard deviation"),
                min=0, max=1, value=1, step=.2, ticks=FALSE),
    sliderInput("sample.size",
                strong("Number of observations in a sample"),
                min=1, max=50, value=20, step=1, ticks=FALSE)
                
  ),

  mainPanel(
    plotOutput("t.stats", width=fig.width, height=fig.height),
    plotOutput("p.values", width=fig.width, height=fig.height)
  )
))