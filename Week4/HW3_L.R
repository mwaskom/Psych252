#HW-3, #L
sink("rhw3sols.r")

d0 = read.csv('mentillness.csv')
d0.y = d0[d0$mentill==1,]
d0.n = d0[d0$mentill==0,]

x1 = min(d0$futhrt); x2 = max(d0$futhrt)		#allows plots for different groups on same axes
y1 = min(d0$guiltcat); y2 = max(d0$guiltcat)

pdf('guiltillnessplots1.pdf')
par(mfrow=c(2,2))

rs0 = lm(guiltcat ~ futhrt, d0)
print(summary(rs0))
g0 = plot(d0$futhrt, d0$guiltcat, type='p', xlim=c(x1,x2), ylim=c(y1,y2), xlab='Future Threat', ylab='Guilt', main='Both Groups', pch=1)
abline(rs0, lty=1)
lines(lowess(d0$futhrt, d0$guiltcat), lty = 2)
legend(x1,y2, c('regress', 'lowess'), lty = 1:2, cex=.7)	#put legend at x=x1, y=y2

rs0y = lm(guiltcat ~ futhrt, d0.y)
print(summary(rs0y))
g0 = plot(d0.y$futhrt, d0.y$guiltcat, type='p', xlim=c(x1,x2), ylim=c(y1,y2), xlab='Future Threat', ylab='Guilt', main='Ment-ill = Yes', pch=1)
abline(rs0y, lty=1)
lines(lowess(d0.y$futhrt, d0.y$guiltcat), lty = 2)
legend(x1,y2, c('regress', 'lowess'), lty = 1:2, cex=.7)	#put legend at x=x1, y=y2

rs0n = lm(guiltcat ~ futhrt, d0.n)
print(summary(rs0n))
g0 = plot(d0.n$futhrt, d0.n$guiltcat, type='p', xlim=c(x1,x2), ylim=c(y1,y2), xlab='Future Threat', ylab='Guilt', main='Ment-ill = No', pch=1)
abline(rs0n, lty=1)
lines(lowess(d0.n$futhrt, d0.n$guiltcat), lty = 2)
legend(x1,y2, c('regress', 'lowess'), lty = 1:2, cex=.7)	#put legend at x=x1, y=y2
graphics.off()

rs1 = lm(futhrt ~ mentill, data=d0, na.action=na.omit)
print(summary(rs1))

#To test 'homogeneity of variance', use var.test(), with 2 samples, or bartlett.test()
rs1a = bartlett.test(futhrt ~ mentill, d0, na.action=na.omit)
print(rs1a)			
cat('\n')

rs2 = lm(guiltcat ~ mentill, d0, na.action=na.omit)
print(summary(rs2))
rs3 = lm(guiltcat ~ mentill + futhrt, d0, na.action=na.omit)
print(summary(rs3))
rs4 = lm(guiltcat ~ mentill * futhrt, d0, na.action=na.omit)
print(summary(rs4))
rs5 = lm(guiltcat ~ mentill * poly(futhrt, 2), d0, na.action=na.omit)
print(summary(rs5))
rs24 = anova(rs2,rs3,rs4, rs5)
print(rs24)

#Maybe guiltcat causes mentill, rather than the other way around!

rs5 = glm(mentill ~ guiltcat, d0, family = binomial, na.action = na.omit)
print(summary(rs5))

#Example of logistic regression: Does guilt influence 'mentill'?
pdf("hw3logistic.pdf")
par(mfrow=c(2,2))
xr = seq(1, 4, .5)		#possible values of Guilt
yc = predict(rs5, data.frame(guiltcat = xr), type = 'response')	#predicted P(mentill) for given levels of guiltcat
plot(d0$guiltcat, d0$mentill, type = 'p', main = 'P(mentill) vs guilt', xlab='guilt',ylab='P(Ment-Ill)')
lines(xr, yc)			#plots predicted curve
graphics.off()

sink(file=NULL, append=FALSE)