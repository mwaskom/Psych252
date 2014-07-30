## add some style elements for ggplot2
library(grid)
plot.style <- opts(panel.grid.major = theme_blank(), panel.grid.minor = theme_blank(),
                   axis.line = theme_segment(colour="black",size=.5),
                   axis.ticks = theme_segment(size=.5),
                   axis.title.x = theme_text(vjust=-.5),
                   axis.title.y = theme_text(angle=90,vjust=0.25),
                   panel.margin = unit(1.5,"lines"))

## standard error of the mean
se.mean <- function (x) {
	sd(x) / sqrt(length(x))
}