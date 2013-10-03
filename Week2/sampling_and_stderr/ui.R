library(shiny)

shinyUI(pageWithSidebar(
  headerPanel("Distributions and Sampling"),
  
  sidebarPanel(
    sliderInput("pop.sd", 
                strong("Population standard deviation"), 
                min=0, max=4, value=2, step=.2, ticks=FALSE),
    sliderInput("n.sample",
                strong("Number of observations in a sample"),
                min=1, max=200, value=20)
  ),

  
  mainPanel(
    div(plotOutput("population", width=500, height=200)),
    div(plotOutput("sample", width=500, height=200,)),
    div(plotOutput("standard.error", width=500, height=200))
  )
))