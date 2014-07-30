## add some style elements for ggplot2
library(grid)
plot.style <- theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
                   axis.line = element_line(colour="black",size=.5),
                   axis.ticks = element_line(size=.5),
                   axis.title.x = element_text(vjust=-.5),
                   axis.title.y = element_text(angle=90,vjust=0.25),
                   panel.margin = unit(1.5,"lines"))

## standard error of the mean
se.mean <- function (x) {
  sd(x) / sqrt(length(x))
}