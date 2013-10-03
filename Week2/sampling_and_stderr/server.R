library(shiny)

shinyServer(function(input, output) {
  
  output$population <- renderPlot({
    x <- seq(-10, 10, length.out=1000)
    pdf <- dnorm(x, 0, input$pop.sd)
    plot(x, pdf, type="l", col="navy", lwd=3, main="Population", frame=FALSE)
  })
  
  output$sample <- renderPlot({
    x <- rnorm(input$n.sample, 0, input$pop.sd)
    x <- x[x > -10 & x < 10]
    hist(x, breaks=seq(-10, 10, 1), col="lightblue", xlim=c(-10, 10),
         main="One Sample from the Population")
    rug(x, col="navy", lwd=2, ticksize=.05)
  })
  
  output$standard.error <- renderPlot({
    sem <- input$pop.sd / sqrt(input$n.sample)
    x <- rnorm(10000, 0, sem)
    hist(x, col="lightcyan", xlim=c(-10, 10), freq=FALSE,
         main="Distribution of Standard Errors of the Mean")
    x.pos <- seq(-10, 10, length.out=1000)
    pdf <- dnorm(x.pos, 0, sem)
    lines(x.pos, pdf, col="navy", lwd=2)
  })
})