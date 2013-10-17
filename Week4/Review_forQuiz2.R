####  Know this for Next Quiz ###
Calculate P(1 < $\chi^{2}$ < 6.25)

# Visualize
hist(rchisq(n=500, df = 3))
abline(v=c(6.25,1), col='red', lty=2)

p1 = pchisq(6.25, df = 3, lower.tail=F); p1
p2 = pchisq(1, df = 3, lower.tail = T); p2
1-p2-p1

# alternately...
p1 = pchisq(6.25, df = 3, lower.tail=T); p1
p2 = pchisq(1, df = 3, lower.tail=T); p1
p1-p2


##### Let's go over what lm() does with categorical 
# and continuous variables ####
d = read.csv('http://www.stanford.edu/class/psych252/data/hw2data.csv')

d.lm1 <- lm(Futurehapp~Responsible, d, na.action=na.omit)
summary(d.lm1)

# What is in our lm object? #
names(d.lm1)  # neat!
d.lm1$coefficients

# What are all these things? #
for (i in names(d.lm1)){
  print(i)
 print(d.lm1[i])
}

# plot the data
plot(d$Futurehapp ~ d$Responsible)

# add our fit line
?abline
abline(d.lm1, col= 'red', lty=3, lwd=3)  # pass in whole object

# We can do it with coefficients as well
d.lm1$coefficients
d.lm1$coefficients[1]
d.lm1$coefficients[2]
abline(d.lm1$coefficients[1],d.lm1$coefficients[2], col= 'blue')  # pass in coefficients

##########

d$Type <- factor(d$Type)
d.lm2 <- lm(Futurehapp~Type, d, na.action=na.omit)
summary(d.lm2)

# plot the data
plot(d$Futurehapp ~ as.numeric(d$Type))
plot(d$Futurehapp ~ d$Type)

# add our fit line
abline(d.lm2, col= 'red')  # pass in whole object

# We can do it with coefficients as well
d.lm2$coefficients
d.lm2$coefficients[1]
d.lm2$coefficients[2]
abline(d.lm2$coefficients[1],d.lm2$coefficients[2], col= 'blue')  # pass in coefficients


# Can calculate at any point on the line 
points(1, d.lm2$coefficients[1] + (1* d.lm2$coefficients[2]), col='green')

# plotting w/ggplot
require(ggplot2)
ggplot(d, aes(x=Type, y=Futurehapp, fill=Type)) + geom_boxplot()


##  Let's talk about reporting in general ##
rs8a_c = lm(Futurehapp~Pasthapp_c+Type+Responsible_c+FTP_c, d, na.action=na.omit)
summary(rs8a_c)

rs8b = lm(Futurehapp~Pasthapp*Type*Responsible*FTP, d, na.action=na.omit)
summary(rs8b)

rs8b_c = lm(Futurehapp~Pasthapp_c*Type*Responsible_c*FTP_c, d, na.action=na.omit)
summary(rs8b_c)
