library(shiny)

shinyServer(function(input, output) {


  n.sim <- 1000
  
  draw.sample <- function(spec){
    sample.data <- rnorm(n.sim * spec$sample.size, spec$true.mean, spec$true.sd)
    sample.data <- matrix(sample.data, nrow=n.sim)
    
    sample.means <- apply(sample.data, 1, mean)
    sample.sems <- apply(sample.data, 1, sd) / sqrt(spec$sample.size)
    
    df = spec$sample.size - 1
    t.stats <- sample.means / sample.sems   
    p.values <- pt(t.stats, df, lower.tail=FALSE)
    
    sig.rate <- sum(p.values < 0.05) / n.sim
    power <- power.t.test(spec$sample.size, spec$true.mean, spec$true.sd, 0.05,
                          type="one.sample", alternative="one.sided")$power
    
    list(df=df, t.stats=t.stats, p.values=p.values, sig.rate=sig.rate, power=power)
    
  }
    
  output$t.stats <- renderPlot({
    
    sample <- draw.sample(input)  
    plot.title <- sprintf("Power: %.2f; Proportion rejected nulls: %.2f", sample$power, sample$sig.rate)
    hist(sample$t.stats, 25, col="dodgerblue", main=plot.title, xlab="t statistics")
    abline(v=qt(0.05, sample$df, lower.tail=FALSE), lwd=5)
    
  })
  
  output$p.values <- renderPlot({
    
    sample <- draw.sample(input)  
    bins <- seq(0, 1, .02)
    hist(sample$p.values, bins, col="tomato", main="", xlab="p values")
    abline(v=0.05, lwd=5)
           
  })
  
})