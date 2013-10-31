Section 10.30.2013 - Interactions, Contrasts, and Mediation
========================================================
## Homework Question A 

What question are we trying to answer?

*Do family-friendly programs in organizations (e.g., flexible work hours, on-site childcare, etc.) have an effect on employee satisfaction?*

Let's clear out our working space, load in the data, etc.

```r
rm(list = ls())

setwd("~/Dropbox/TA/Psych252_MW/WWW/datasets")
d <- read.csv("families.csv")
```


Taking a look at the data.


```r
str(d)
```

```
## 'data.frame':	68 obs. of  3 variables:
##  $ famprog : int  5 9 1 9 3 2 2 2 6 5 ...
##  $ empsatis: num  3.29 5.63 3.92 2.51 5.28 ...
##  $ perfam  : int  66 41 53 54 49 53 70 53 58 43 ...
```


Now we know that we have:
`N = 68` companies in our sample

**Measures**

`famprog:` the amount of family-friendly programs from (1) Nothing at all to (9) Amazing family-friendliness

`empsatis:` the average rating of employee satisfaction from (1) Extremely unsatisfied to (7) Extremely satisfied

`perfam:` the percentage of employees with families in the organization from 0% to 100%

**(a) Describe the data**

Note the plots in your homework! The plot on the right can only be created if you factor the variables. (We'll do this later, because we probably would want to keep these variables as continuous when working with them.) The coplot you can create using continuous variables!


```r
with(d, coplot(empsatis ~ famprog | perfam))
```

![plot of chunk coplot](figure/coplot.png) 


Let's also take a moment to check out our DV, employee satisfaction.


```r
hist(d$empsatis)
```

![plot of chunk unnamed-chunk-1](figure/unnamed-chunk-1.png) 


**(c) Main effects: Does the number of programs affect employee satisfaction? Is the percentage of families who use the programs correlated with employee satisfaction?**

We could run a simple regression where `famprog`, the number of family-friendly programs, predicts `empsatis`, employee satisfaction


```r
with(d, summary(lm(empsatis ~ famprog)))
```

```
## 
## Call:
## lm(formula = empsatis ~ famprog)
## 
## Residuals:
##     Min      1Q  Median      3Q     Max 
## -1.6779 -0.5365 -0.0348  0.4285  1.7152 
## 
## Coefficients:
##             Estimate Std. Error t value Pr(>|t|)    
## (Intercept)   3.5810     0.2182   16.41   <2e-16 ***
## famprog       0.0670     0.0366    1.83    0.072 .  
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 0.754 on 66 degrees of freedom
## Multiple R-squared:  0.0484,	Adjusted R-squared:  0.034 
## F-statistic: 3.36 on 1 and 66 DF,  p-value: 0.0715
```


Seems like the asnwer is yes, but we have a weak effect. Can we do something to describe the data better? Taking a look at our plot, what do we think might be going on?

We could use our other predictor `perfam`, and look for an interaction on employee satisfaction.


```r
with(d, summary(lm(empsatis ~ famprog * perfam)))
```

```
## 
## Call:
## lm(formula = empsatis ~ famprog * perfam)
## 
## Residuals:
##     Min      1Q  Median      3Q     Max 
## -1.6592 -0.3919 -0.0431  0.4675  1.5906 
## 
## Coefficients:
##                Estimate Std. Error t value Pr(>|t|)    
## (Intercept)     6.72859    1.32190    5.09  3.4e-06 ***
## famprog        -0.34384    0.20260   -1.70    0.095 .  
## perfam         -0.05674    0.02352   -2.41    0.019 *  
## famprog:perfam  0.00740    0.00359    2.06    0.044 *  
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 0.732 on 64 degrees of freedom
## Multiple R-squared:  0.131,	Adjusted R-squared:  0.0903 
## F-statistic: 3.22 on 3 and 64 DF,  p-value: 0.0286
```


Now that we see the expected interaction how do we interpret the lower order effects? We will see how to get a decent interpretation later. For now we know that it can't possibly mean that there is a negative relationship between famprog and satisfaction because we saw the data and the model above. 

Let's try centering both of our variables and see if we can get a better intuition.


```r
with(d, summary(lm(empsatis ~ scale(famprog, scale = F) * scale(perfam, scale = F))))
```

```
## 
## Call:
## lm(formula = empsatis ~ scale(famprog, scale = F) * scale(perfam, 
##     scale = F))
## 
## Residuals:
##     Min      1Q  Median      3Q     Max 
## -1.6592 -0.3919 -0.0431  0.4675  1.5906 
## 
## Coefficients:
##                                                    Estimate Std. Error
## (Intercept)                                         3.94433    0.08875
## scale(famprog, scale = F)                           0.06526    0.03553
## scale(perfam, scale = F)                           -0.01670    0.00892
## scale(famprog, scale = F):scale(perfam, scale = F)  0.00740    0.00359
##                                                    t value Pr(>|t|)    
## (Intercept)                                          44.44   <2e-16 ***
## scale(famprog, scale = F)                             1.84    0.071 .  
## scale(perfam, scale = F)                             -1.87    0.066 .  
## scale(famprog, scale = F):scale(perfam, scale = F)    2.06    0.044 *  
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 0.732 on 64 degrees of freedom
## Multiple R-squared:  0.131,	Adjusted R-squared:  0.0903 
## F-statistic: 3.22 on 3 and 64 DF,  p-value: 0.0286
```


Do the lower order coefficients conform to our intuitions better now?

Compare the p-value of `famprog` with that obtained without an interaction term.

**(c) Do family-friendly programs improve employee satisfaction overall?**

Answer: Yes, there is a marginal positive main effect of the number of family programs on employee satisfaction, and we would give the b, t, df, and p
Use df from residual SE at bottom of lm output
`b = .07, t(64) = 1.84, p = .07`

**(d) Does the percentage of employees with families impact the effect of family programs on employee satisfaction?**

Answer: There is a significant interaction between the number of family programs available and the percentage of families who use these programs,
`b = .007, t(64) = 2.06, p = .04`

**(e) Interpret the answer by examining the effect of family programs on employee satisfaction for companies who have the average number of employees with families**

Revisit our centered lm:


```r
with(d, summary(lm(empsatis ~ scale(famprog, scale = F) * scale(perfam, scale = F))))
```

```
## 
## Call:
## lm(formula = empsatis ~ scale(famprog, scale = F) * scale(perfam, 
##     scale = F))
## 
## Residuals:
##     Min      1Q  Median      3Q     Max 
## -1.6592 -0.3919 -0.0431  0.4675  1.5906 
## 
## Coefficients:
##                                                    Estimate Std. Error
## (Intercept)                                         3.94433    0.08875
## scale(famprog, scale = F)                           0.06526    0.03553
## scale(perfam, scale = F)                           -0.01670    0.00892
## scale(famprog, scale = F):scale(perfam, scale = F)  0.00740    0.00359
##                                                    t value Pr(>|t|)    
## (Intercept)                                          44.44   <2e-16 ***
## scale(famprog, scale = F)                             1.84    0.071 .  
## scale(perfam, scale = F)                             -1.87    0.066 .  
## scale(famprog, scale = F):scale(perfam, scale = F)    2.06    0.044 *  
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 0.732 on 64 degrees of freedom
## Multiple R-squared:  0.131,	Adjusted R-squared:  0.0903 
## F-statistic: 3.22 on 3 and 64 DF,  p-value: 0.0286
```


Because we've centered (at the mean), the simple effects reported here are at the mean

So for the number of family programs at the mean of the percentage of families who use the programs, `b = .065, p = .07`

So, what did we mean above by the main effect? Lesson: don't rely on these terms to make yourself understood. Be clear in describing your interpretation and exactly what it means. This is also helpful in coming up with a good mechanistic interpretation. 

**(e) Interpret the answer by examining the effect of family programs on employee satisfaction for companies at +1SD and -1SD of mean % who use programs**

Say we want to know about companies that have a lot of employees with families who use these programs (+1SD). We calculate this by subtracting 1SD from centered value.


```r
with(d, summary(lm(empsatis ~ scale(famprog, scale = F) * I(scale(perfam, scale = F) - 
    sd(perfam)))))
```

```
## 
## Call:
## lm(formula = empsatis ~ scale(famprog, scale = F) * I(scale(perfam, 
##     scale = F) - sd(perfam)))
## 
## Residuals:
##     Min      1Q  Median      3Q     Max 
## -1.6592 -0.3919 -0.0431  0.4675  1.5906 
## 
## Coefficients:
##                                                                    Estimate
## (Intercept)                                                         3.77012
## scale(famprog, scale = F)                                           0.14243
## I(scale(perfam, scale = F) - sd(perfam))                           -0.01670
## scale(famprog, scale = F):I(scale(perfam, scale = F) - sd(perfam))  0.00740
##                                                                    Std. Error
## (Intercept)                                                           0.12851
## scale(famprog, scale = F)                                             0.05105
## I(scale(perfam, scale = F) - sd(perfam))                              0.00892
## scale(famprog, scale = F):I(scale(perfam, scale = F) - sd(perfam))    0.00359
##                                                                    t value
## (Intercept)                                                          29.34
## scale(famprog, scale = F)                                             2.79
## I(scale(perfam, scale = F) - sd(perfam))                             -1.87
## scale(famprog, scale = F):I(scale(perfam, scale = F) - sd(perfam))    2.06
##                                                                    Pr(>|t|)
## (Intercept)                                                          <2e-16
## scale(famprog, scale = F)                                            0.0069
## I(scale(perfam, scale = F) - sd(perfam))                             0.0656
## scale(famprog, scale = F):I(scale(perfam, scale = F) - sd(perfam))   0.0435
##                                                                       
## (Intercept)                                                        ***
## scale(famprog, scale = F)                                          ** 
## I(scale(perfam, scale = F) - sd(perfam))                           .  
## scale(famprog, scale = F):I(scale(perfam, scale = F) - sd(perfam)) *  
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 0.732 on 64 degrees of freedom
## Multiple R-squared:  0.131,	Adjusted R-squared:  0.0903 
## F-statistic: 3.22 on 3 and 64 DF,  p-value: 0.0286
```


So for the number of family programs at +1SD above the mean of the percentage of families who use programs, the effect of family programs on employee satisfaction is `b = .14, p < .01.`

*Remember that we subtract one SD to describe the effect at one SD above the mean! You're subtracting these levels from your centered variable, so in the case of -1 SD, so +1 SD*

Now, for companies with few families who use these progrmas, we'll look at -1SD below the mean of the percentage of families who use these programs


```r
with(d, summary(lm(empsatis ~ scale(famprog, scale = F) * I(scale(perfam, scale = F) + 
    sd(perfam)))))
```

```
## 
## Call:
## lm(formula = empsatis ~ scale(famprog, scale = F) * I(scale(perfam, 
##     scale = F) + sd(perfam)))
## 
## Residuals:
##     Min      1Q  Median      3Q     Max 
## -1.6592 -0.3919 -0.0431  0.4675  1.5906 
## 
## Coefficients:
##                                                                    Estimate
## (Intercept)                                                         4.11854
## scale(famprog, scale = F)                                          -0.01192
## I(scale(perfam, scale = F) + sd(perfam))                           -0.01670
## scale(famprog, scale = F):I(scale(perfam, scale = F) + sd(perfam))  0.00740
##                                                                    Std. Error
## (Intercept)                                                           0.12860
## scale(famprog, scale = F)                                             0.05223
## I(scale(perfam, scale = F) + sd(perfam))                              0.00892
## scale(famprog, scale = F):I(scale(perfam, scale = F) + sd(perfam))    0.00359
##                                                                    t value
## (Intercept)                                                          32.03
## scale(famprog, scale = F)                                            -0.23
## I(scale(perfam, scale = F) + sd(perfam))                             -1.87
## scale(famprog, scale = F):I(scale(perfam, scale = F) + sd(perfam))    2.06
##                                                                    Pr(>|t|)
## (Intercept)                                                          <2e-16
## scale(famprog, scale = F)                                             0.820
## I(scale(perfam, scale = F) + sd(perfam))                              0.066
## scale(famprog, scale = F):I(scale(perfam, scale = F) + sd(perfam))    0.044
##                                                                       
## (Intercept)                                                        ***
## scale(famprog, scale = F)                                             
## I(scale(perfam, scale = F) + sd(perfam))                           .  
## scale(famprog, scale = F):I(scale(perfam, scale = F) + sd(perfam)) *  
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 0.732 on 64 degrees of freedom
## Multiple R-squared:  0.131,	Adjusted R-squared:  0.0903 
## F-statistic: 3.22 on 3 and 64 DF,  p-value: 0.0286
```


`b = -.01, ns`

Answer: List the simple effects at each level.

For companies where few families use the family programs, the number of programs does not affect employee satisfaction, `b = -.01, t(64) = -.23, p >.80.` However, for companies where a lot of families use the family programs, the number of family programs is associated with higher employee satisfaction, `b = .14, t(64) = 2.70, p = .007.`

**(f) What do you conclude? Write out the story. Remember to use the appropriate numbers to make the story as useful as possible!**


```r
mean(d$perfam)
```

```
## [1] 55.29
```

```r
mean(d$perfam) + sd(d$perfam)
```

```
## [1] 65.73
```

```r
mean(d$perfam) - sd(d$perfam)
```

```
## [1] 44.86
```


## Contrasts

Let's say that we wanted to transform the predictors into categorical variables, using one or more categorical variables with different means on a quantitative variable. (*What kind of test is this?*)

There are a few different decisions we as researchers could make at this point. Do we want to create a categorical variable with two groups (*High and Low number of programs*) or multiple groups (*Low, Middle, and High number of programs*)? How should we split up our other variables of interest? These are examples of the subjective decisions you make as researchers!

To make two equal groups, we'll split the variable using the `median` function.  Then, we change it into a categorical variable using the `findInterval` function.  


```r
quantfp2 = median(d$famprog)
print(quantfp2)
```

```
## [1] 6
```

```r
d$famprogcat = findInterval(d$famprog, quantfp2)

table(d$famprogcat)
```

```
## 
##  0  1 
## 33 35
```

```r

d$FPcat <- factor(d$famprogcat, labels = c("lowprog", "highprog"))
table(d$FPcat)
```

```
## 
##  lowprog highprog 
##       33       35
```


Another quick way to do this would be to find the median and then use the `ifelse` function to create the new variable.


```r
median(d$famprog)
```

```
## [1] 6
```

```r
d$Fcat <- ifelse(d$famprog < 6, c("highprog"), c("lowprog"))

table(d$Fcat)
```

```
## 
## highprog  lowprog 
##       33       35
```


To make three groups, we'll use the `quantile` function to divide our variable `perfam`, the percentage of employees with families in the orgnanization, into thirds (*note that we've specified our probabilities as .33 and .66 accordingly). Again we change it into a categorical variable using the `findInterval` function.  This will allow us to have a categorical variable with three equal groups. 


```r
quantpf3 = quantile(d$perfam, probs = c(0.34, 0.66))
print(quantpf3)
```

```
##   34%   66% 
## 51.78 59.00
```

```r
d$perfamcat = findInterval(d$perfam, quantpf3)

table(d$perfamcat)
```

```
## 
##  0  1  2 
## 23 20 25
```

```r

d$PerCat <- factor(d$perfamcat, labels = c("low use", "middle use", "high use"))
table(d$PerCat)
```

```
## 
##    low use middle use   high use 
##         23         20         25
```


Here's another way to create multiple categories in your data!  We can specify our values calculated above, 51.78, 59


```r
d$PCat[d$perfam < 51.7] <- "Low Use"
d$PCat[d$perfam > 51.7 & d$perfam < 59] <- "Middle Use"
d$PCat[d$perfam >= 59] <- "High Use"

table(d$PCat)
```

```
## 
##   High Use    Low Use Middle Use 
##         25         23         20
```



```r
str(d)  # note variables that are chr not factor! problem for contrasts
```

```
## 'data.frame':	68 obs. of  9 variables:
##  $ famprog   : int  5 9 1 9 3 2 2 2 6 5 ...
##  $ empsatis  : num  3.29 5.63 3.92 2.51 5.28 ...
##  $ perfam    : int  66 41 53 54 49 53 70 53 58 43 ...
##  $ famprogcat: int  0 1 0 1 0 0 0 0 1 0 ...
##  $ FPcat     : Factor w/ 2 levels "lowprog","highprog": 1 2 1 2 1 1 1 1 2 1 ...
##  $ Fcat      : chr  "highprog" "lowprog" "highprog" "lowprog" ...
##  $ perfamcat : int  2 0 1 1 0 1 2 1 1 0 ...
##  $ PerCat    : Factor w/ 3 levels "low use","middle use",..: 3 1 2 2 1 2 3 2 2 1 ...
##  $ PCat      : chr  "High Use" "Low Use" "Middle Use" "Middle Use" ...
```

```r
contrasts(d$Fcat) = cbind(-1, 1)
```

```
## Error: contrasts apply only to factors
```


Let's plot our data! 


```r
with(d, {
    interaction.plot(FPcat, PerCat, empsatis, xlab = "Number of Programs", ylab = "Employee Satisfaction", 
        trace.label = "Percentage Use")
})
```

![plot of chunk plotting](figure/plotting.png) 


How can we make bar graphs?  (Since we're using two categorical predictors)

We'll also add error bars! Since they're easier to eyeball (remember the paper Benoit mentioned in class!), we'll include the 95% confidence interval, though I'll give you a formula for the standard error that you could use too.


```r
sem <- function(x) {
    sd(x)/sqrt(length(x))
}

ci95 <- function(x) {
    sem(x) * 1.96
}
```



```r
ms <- aggregate(empsatis ~ FPcat + PerCat, data=d, mean)
ms$errs <- aggregate(empsatis ~ FPcat + PerCat, data=d, ci95)$empsatis
print(ms)
```

```
##      FPcat     PerCat empsatis   errs
## 1  lowprog    low use    4.063 0.6053
## 2 highprog    low use    4.223 0.5312
## 3  lowprog middle use    3.794 0.2708
## 4 highprog middle use    3.887 0.4215
## 5  lowprog   high use    3.498 0.2805
## 6 highprog   high use    4.150 0.4123
```

```r

library(ggplot2)
ggplot(ms, aes(x=FPcat, y=empsatis, fill=PerCat)) + 
  geom_bar(position=position_dodge(), stat="identity", colour="black", size=.3) + # Use black outlines
  geom_errorbar(aes(ymin = ms$empsatis-ms$errs, ymax=ms$empsatis+ms$errs), width=.2, position=position_dodge(width=.9)) +
  xlab("Number of Programs") +
  ylab("Employee Satisfaction") +
  theme_bw()
```

![plot of chunk plotting error bars](figure/plotting_error_bars.png) 


Let's revisit our data, but just take a look at the companies that had a low number of programs, since that seemed to be where interesting things were happening!


```r
l <- subset(d, FPcat == "lowprog")
str(l)
```

```
## 'data.frame':	33 obs. of  9 variables:
##  $ famprog   : int  5 1 3 2 2 2 5 3 4 1 ...
##  $ empsatis  : num  3.29 3.92 5.28 4.03 2.94 ...
##  $ perfam    : int  66 53 49 53 70 53 43 42 44 44 ...
##  $ famprogcat: int  0 0 0 0 0 0 0 0 0 0 ...
##  $ FPcat     : Factor w/ 2 levels "lowprog","highprog": 1 1 1 1 1 1 1 1 1 1 ...
##  $ Fcat      : chr  "highprog" "highprog" "highprog" "highprog" ...
##  $ perfamcat : int  2 1 0 1 2 1 0 0 0 0 ...
##  $ PerCat    : Factor w/ 3 levels "low use","middle use",..: 3 2 1 2 3 2 1 1 1 1 ...
##  $ PCat      : chr  "High Use" "Middle Use" "Low Use" "Middle Use" ...
```


What if we change our contrasts? What predictions might we make using the data?


```r
plot(l$PerCat, l$empsatis)
```

![plot of chunk contrasts](figure/contrasts.png) 

```r
levels(l$PerCat)
```

```
## [1] "low use"    "middle use" "high use"
```

```r
contrasts(l$PerCat) = cbind(c(-1, -1, 2), c(-1, 1, 0))  #which groups are these contrasts comparing?

with(l, summary(lm(empsatis ~ PerCat)))
```

```
## 
## Call:
## lm(formula = empsatis ~ PerCat)
## 
## Residuals:
##    Min     1Q Median     3Q    Max 
## -1.315 -0.237 -0.119  0.348  1.434 
## 
## Coefficients:
##             Estimate Std. Error t value Pr(>|t|)    
## (Intercept)   3.7852     0.1166   32.46   <2e-16 ***
## PerCat1      -0.1434     0.0806   -1.78    0.085 .  
## PerCat2      -0.1346     0.1459   -0.92    0.364    
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 0.668 on 30 degrees of freedom
## Multiple R-squared:  0.116,	Adjusted R-squared:  0.0568 
## F-statistic: 1.96 on 2 and 30 DF,  p-value: 0.158
```


We've talked in class about contrasts that are orthogonal. Why do we want to create orthogonal contrasts?

Let's create a formula to test whether contrasts are orthogonal (if we have three groups)!


```r
c_orth_3 <- function(x) {
    (x[1, 1] * x[1, 2]) + (x[2, 1] * x[2, 2]) + (x[3, 1] * x[3, 2])
}
```


Let's create some orthogonal and non-orthogonal contrasts and see if our function works.


```r
c1 <- cbind(c(-2, 1, 1), c(0, 1, -1))
c_orth_3(c1)
```

```
## [1] 0
```

```r
c2 <- cbind(c(-2, 1, 1), c(1, 1, -2))
c_orth_3(c2)
```

```
## [1] -3
```

```r
c3 <- cbind(c(-2, 1, 1), c(1, 1, -3))
c_orth_3(c3)  #Remember contrasts must sum to 0!
```

```
## [1] -4
```


Now let's see if we can create a function for other contrasts!


```r
c_orth_4 <- function(x) {
    a <- (x[1, 1] * x[1, 2]) + (x[2, 1] * x[2, 2]) + (x[3, 1] * x[3, 2]) + (x[4, 
        1] * x[4, 2])
    b <- (x[1, 2] * x[1, 3]) + (x[2, 2] * x[2, 3]) + (x[3, 2] * x[3, 3]) + (x[4, 
        2] * x[4, 3])
    c <- (x[1, 1] * x[1, 3]) + (x[2, 1] * x[2, 3]) + (x[3, 1] * x[3, 3]) + (x[4, 
        1] * x[4, 3])
    d <- cbind(a, b, c)
    rownames(d) = c("Contrasts")
    print(d)
    e <- a + b + c
    names(e) = c("Sum")
    print(e)
}
```




```r
c1 <- cbind(c(-3, 1, 1, 1), c(0, 0, 1, -1), c(-1, 1, 1, -1))
c_orth_4(c1)
```

```
##           a b c
## Contrasts 0 2 4
## Sum 
##   6
```

```r
c2 <- cbind(c(1, 1, -1, -1), c(1, -1, 1, -1), c(-1, 1, 1, -1))
c_orth_4(c2)
```

```
##           a b c
## Contrasts 0 0 0
## Sum 
##   0
```


Let's take a closer look at each of these contrasts to see what groups they would be comparing!


```r
print(c2)
```

```
##      [,1] [,2] [,3]
## [1,]    1    1   -1
## [2,]    1   -1    1
## [3,]   -1    1    1
## [4,]   -1   -1   -1
```


## Question E - Mediation!

Let's clean up our screens and load in the next data set!


```r
rm(list = ls())

setwd("~/Dropbox/TA/Psych252_MW/WWW/datasets")
d <- read.csv("caffeine.csv")
str(d)
```

```
## 'data.frame':	62 obs. of  4 variables:
##  $ coffee : int  1 1 1 1 2 1 1 1 2 1 ...
##  $ perf   : int  53 9 31 38 40 40 9 37 62 23 ...
##  $ accur  : num  0.45 0.5 0.499 0.454 0.421 ...
##  $ numprob: int  7 6 6 7 8 6 6 8 7 7 ...
```


**Measures**

What mediational question might we ask with these data?

**IV**: *Coffee* - 20 subjects in each group either had 0 cups, 2 cups, or 4 cups

**DV**: *Performance* - on a stats quiz with 10 problems, 5-89 points

**Possible Mediator 1**: *Number of problems attempted* (hyperactivity)

**Possible Mediator 2**: *Accuracy* - how likely they were to get a problem right if they tried (better success)

What should we do first?


```r
hist(d$perf)
```

![plot of chunk unnamed-chunk-11](figure/unnamed-chunk-11.png) 

```r
table(d$coffee)
```

```
## 
##  1  2  3 
## 20 20 20
```


We should probably recode coffee cups into number of coffee cups!


```r
d$cups = 0 * as.numeric(d$coffee == 1) + 2 * as.numeric(d$coffee == 2) + 4 * 
    as.numeric(d$coffee == 3)
table(d$cups)
```

```
## 
##  0  2  4 
## 20 20 20
```


First question: Does the number of problems attempted (hyperactivity) mediate the effect of coffee on performance?

We need to run three models. There is one model that we never run (the effect of the mediator on the DV, without the IV included):


```r
with(d, summary(lm(perf ~ numprob)))
```

```
## 
## Call:
## lm(formula = perf ~ numprob)
## 
## Residuals:
##    Min     1Q Median     3Q    Max 
## -29.66 -11.30  -0.17  10.28  39.79 
## 
## Coefficients:
##             Estimate Std. Error t value Pr(>|t|)    
## (Intercept)    -9.17      14.84   -0.62  0.53898    
## numprob         6.48       1.85    3.51  0.00087 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 16.8 on 58 degrees of freedom
##   (2 observations deleted due to missingness)
## Multiple R-squared:  0.175,	Adjusted R-squared:  0.161 
## F-statistic: 12.3 on 1 and 58 DF,  p-value: 0.000872
```


The first model we need to look at is the direct path, does coffee predict performance?  If not, we can abandon this whole endeavor!


```r
problm1 <- lm(perf ~ cups, data = d)
summary(problm1)  # yes, it predicts, c=3.74
```

```
## 
## Call:
## lm(formula = perf ~ cups, data = d)
## 
## Residuals:
##    Min     1Q Median     3Q    Max 
## -31.84 -11.85  -0.37   8.63  43.11 
## 
## Coefficients:
##             Estimate Std. Error t value Pr(>|t|)    
## (Intercept)    34.89       3.56    9.80  6.4e-14 ***
## cups            3.74       1.38    2.71   0.0088 ** 
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 17.4 on 58 degrees of freedom
##   (2 observations deleted due to missingness)
## Multiple R-squared:  0.112,	Adjusted R-squared:  0.0972 
## F-statistic: 7.35 on 1 and 58 DF,  p-value: 0.0088
```

```r
c <- problm1$coefficients[2]  # We'll save our coefficients for our Sobel test later!

problm1 <- lm(perf ~ coffee, data = d)  # Note that we get the same results whether we recode coffee or not, just different coefficients
summary(problm1)
```

```
## 
## Call:
## lm(formula = perf ~ coffee, data = d)
## 
## Residuals:
##    Min     1Q Median     3Q    Max 
## -31.84 -11.85  -0.37   8.63  43.11 
## 
## Coefficients:
##             Estimate Std. Error t value Pr(>|t|)    
## (Intercept)    27.42       5.96    4.60  2.3e-05 ***
## coffee          7.47       2.76    2.71   0.0088 ** 
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 17.4 on 58 degrees of freedom
##   (2 observations deleted due to missingness)
## Multiple R-squared:  0.112,	Adjusted R-squared:  0.0972 
## F-statistic: 7.35 on 1 and 58 DF,  p-value: 0.0088
```


Now let's check out Model 2, whether the IV affects the mediator, in other words, does coffee predict the number of problems attempted?


```r
problm2 <- lm(numprob ~ cups, data = d)
summary(problm2)  # yes, a=0.52
```

```
## 
## Call:
## lm(formula = numprob ~ cups, data = d)
## 
## Residuals:
##    Min     1Q Median     3Q    Max 
##  -1.00  -0.90   0.05   1.00   2.05 
## 
## Coefficients:
##             Estimate Std. Error t value Pr(>|t|)    
## (Intercept)   6.9000     0.1668   41.36  < 2e-16 ***
## cups          0.5250     0.0646    8.12  3.8e-11 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 0.817 on 58 degrees of freedom
##   (2 observations deleted due to missingness)
## Multiple R-squared:  0.532,	Adjusted R-squared:  0.524 
## F-statistic:   66 on 1 and 58 DF,  p-value: 3.79e-11
```

```r
a <- summary(problm2)$coefficients[2, 1]
s_a <- summary(problm2)$coefficients[2, 2]
```


Our final model, Model 3, is the effect of coffee on performance mediated by the effect of the number of problems.


```r
problm3 <- lm(perf ~ cups + numprob, data = d)
summary(problm3)
```

```
## 
## Call:
## lm(formula = perf ~ cups + numprob, data = d)
## 
## Residuals:
##    Min     1Q Median     3Q    Max 
## -29.60 -11.56  -0.13   9.26  39.10 
## 
## Coefficients:
##             Estimate Std. Error t value Pr(>|t|)  
## (Intercept)   -4.843     19.087   -0.25    0.801  
## cups           0.714      1.958    0.36    0.717  
## numprob        5.759      2.721    2.12    0.039 *
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 16.9 on 57 degrees of freedom
##   (2 observations deleted due to missingness)
## Multiple R-squared:  0.177,	Adjusted R-squared:  0.148 
## F-statistic: 6.14 on 2 and 57 DF,  p-value: 0.00386
```

```r

c_prime <- summary(problm3)$coefficients[2, 1]
b <- summary(problm3)$coefficients[3, 1]
s_b <- summary(problm3)$coefficients[3, 2]
```


The direct effect of coffee (c) disappeared and the number of problems attempted (b) is significant. We could answer yes, there is mediation, but let's be more formal.

Let's perform  the conventional Sobel test, adding in the standard error of a and standard error of b.


```r
s_ab <- sqrt(b^2 * s_a^2 + a^2 * s_b^2 + s_a^2 * s_b^2)
s_ab  # standard error of a*b
```

```
## [1] 1.486
```

```r
p_s_ab <- pnorm(a * b/s_ab, lower.tail = F)
p_s_ab  # p of ratio of a*b over its s.e.
```

```
## [1] 0.02098
```


Now let's repeat the procedure for the second mediation analysis. The question now is: does accuracy meadiate the effect of coffee on performance? 

We did Model 1 above and have significant c (the direct path)

Now let's move on to Model 2, does coffee predict accuracy?


```r
accurm2 <- lm(accur ~ cups, data = d)
summary(accurm2)
```

```
## 
## Call:
## lm(formula = accur ~ cups, data = d)
## 
## Residuals:
##      Min       1Q   Median       3Q      Max 
## -0.27062 -0.08471 -0.00076  0.08388  0.23812 
## 
## Coefficients:
##              Estimate Std. Error t value Pr(>|t|)    
## (Intercept)  0.511140   0.022174   23.05   <2e-16 ***
## cups        -0.000143   0.008588   -0.02     0.99    
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 0.109 on 58 degrees of freedom
##   (2 observations deleted due to missingness)
## Multiple R-squared:  4.77e-06,	Adjusted R-squared:  -0.0172 
## F-statistic: 0.000277 on 1 and 58 DF,  p-value: 0.987
```


No, coffee consumption does not predict accuracy, so according to Baron & Kenny we can stop and conclude there is no mediation. But lets procede, using a=-0.00014.


```r
a2 <- summary(accurm2)$coefficients[2, 1]
s_a2 <- summary(accurm2)$coefficients[2, 2]
```


Now model 3, is the effect of coffee on performance mediated by the effect of accuracy?


```r
accurm3 <- lm(perf ~ cups + accur, data = d)
summary(accurm3)  # now the effect of coffee remains as well as an effect of accur.
```

```
## 
## Call:
## lm(formula = perf ~ cups + accur, data = d)
## 
## Residuals:
##    Min     1Q Median     3Q    Max 
## -34.08  -9.88  -0.83   7.82  42.35 
## 
## Coefficients:
##             Estimate Std. Error t value Pr(>|t|)   
## (Intercept)     8.93      10.86    0.82   0.4144   
## cups            3.74       1.32    2.84   0.0063 **
## accur          50.80      20.17    2.52   0.0146 * 
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 16.7 on 57 degrees of freedom
##   (2 observations deleted due to missingness)
## Multiple R-squared:  0.201,	Adjusted R-squared:  0.173 
## F-statistic: 7.19 on 2 and 57 DF,  p-value: 0.00165
```

```r

b2 <- summary(accurm3)$coefficients[3, 1]
s_b2 <- summary(accurm3)$coefficients[3, 2]
```


Perform conventional sobel test, adding standard error of a and b.


```r
s_ab2 <- sqrt(b2^2 * s_a2^2 + a2^2 * s_b2^2 + s_a2^2 * s_b2^2)
s_ab2  # standard error of a*b
```

```
## [1] 0.4694
```

```r
p_s_ab2 <- pnorm(a2 * b2/s_ab2, lower.tail = F)
p_s_ab2  # p of ratio of a2*b2 over its s.e.
```

```
## [1] 0.5062
```


Conclusion: Coffee and accuracy both contribute to performance and in this case there is no mediation there. However, the effect of coffee is mediated by the number of problems attempted. 
