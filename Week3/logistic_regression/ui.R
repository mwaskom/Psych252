library(shiny)

fig.width <- 600
fig.height <- 450

shinyUI(pageWithSidebar(
  
  headerPanel("Simple Logistic Regression"),
  
  sidebarPanel(
    
    div(p("Try to find values for the slope and intercept that maximize the likelihood of the data.")),
    div(
      
      sliderInput("intercept",
                  strong("Intercept"),
                  min=-3, max=3, step=.25,
                  value=sample(seq(-3, 3, .25), 1), ticks=FALSE),
      sliderInput("slope", 
                  strong("Slope"),
                  min=-3, max=3, step=.25, 
                  value=sample(seq(-2, 2, .25), 1), ticks=FALSE)
      
    )
  ),

  mainPanel(
    div(plotOutput("reg.plot", width=fig.width, height=fig.height),
        title="y = 2 + x"),
    div(plotOutput("like.plot", width=fig.width, height=fig.height / 3))
  )
    
))