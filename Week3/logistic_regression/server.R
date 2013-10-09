library(shiny)
library(RColorBrewer)

shinyServer(function(input, output) {

  # --------------------------------------------------------------------------
  # Get a set of random data with a fixed true model
  draw.sample <- reactive({
    # This gets called whenever the app is reloaded
    
    # Hardcode the true relationship
    n.obs = 30
    true.a <- .75
    true.b <- 1.25
    
    x <- runif(n.obs, -5, 5)
    prob.x <- exp(true.a + true.b * x) / (1 + exp(true.a + true.b * x))
    y <- rbinom(n.obs, 1, prob.x)
    prob.data <- dbinom(y, 1, prob.x)
    
    return(list(x=x, y=y, prob.x=prob.x))
    
  })
  
  # --------------------------------------------------------------------------
  # Calculate the current values of the model given the inputs
  regression <- reactive({
    
    # Get shorthand access to the attributes we care about
    data.vals <- draw.sample()
    x <- data.vals$x
    y <- data.vals$y
    a <- input$intercept
    b <- input$slope
    
    # Calculate the probability of the data given the current model
    prob.hat <- exp(a + b * x) / (1 + exp(a + b * x))
    prob.data = dbinom(y, 1, prob.hat)
    log.like <- sum(log(prob.data))
    
    return(list(x=x, y=y, a=a, b=b,
                prob.data=prob.data,
                log.like=log.like))

  })

  #---------------------------------------------------------------------------
  # Plot a scatter of the data and the current model with residuals
  output$reg.plot <- renderPlot({         
  
    # Get the current regression data
    reg.data <- regression()
    a <- reg.data$a
    b <- reg.data$b
    x <- reg.data$x
    y <- reg.data$y
    prob.data <- reg.data$prob.data
    
    # Plot the regression curve
    x.vals <- seq(-5, 5, .01)
    y.vals <- exp(a + b * x.vals) / (1 + exp(a + b * x.vals))
    plot(x.vals, y.vals, type="l", lwd=3, col="dimgray",
         bty="n", xlim=c(-5, 5), ylim=c(0, 1), xlab="x", ylab="y",
         main="Logistic model Y ~ X")
    
    # Plot the observations
    color.idx <- pmax(floor(prob.data * 10), 1)
    color.bin <- rev(brewer.pal(9, "RdPu"))[color.idx]
    points(x, y,  pch=21, cex=1.5, col="black", bg=color.bin)
  
    # Plot the current equation as a legend
    equation = sprintf("logit(y) = %.3g + %.3g * x", a, b)
    legend(1, .2, equation, lty=1, lwd=2, bty="n")
    
  })
  
  #---------------------------------------------------------------------------
  # Plot the current sum squares along with the minumum possible
  output$like.plot <- renderPlot({
    
    # Get the current regression data
    reg.data <- regression()
    log.like <- reg.data$log.like

    # Plot the two points
    plot(log.like, 1, cex=2, yaxt="n", bty="n", pch=16, col="dimgray",
         xlim=c(-50, 0), ylab="", xlab="", main="Log-likelihood of the data")
    
  })
  
})