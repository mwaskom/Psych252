Psych 252: Running General Linear Models with `lm()`
========================================================

Load in data
-------------

```r
d0 = read.csv("http://www.stanford.edu/class/psych252/data/mentillness.csv")
str(d0)
```

```
## 'data.frame':	240 obs. of  9 variables:
##  $ guilt   : int  1 1 1 1 1 1 1 1 1 1 ...
##  $ mentill : int  1 1 1 1 1 1 1 1 1 1 ...
##  $ futhrt  : int  4 3 8 5 6 7 3 3 4 4 ...
##  $ se      : num  0.0518 0.0518 0.0518 0.0518 0.0518 ...
##  $ z       : num  2.51 2.51 2.51 2.51 2.51 ...
##  $ pp      : num  0.00599 0.00599 0.00599 0.00599 0.00599 ...
##  $ futthcat: int  4 3 6 5 6 6 3 3 4 4 ...
##  $ guiltq  : num  0.3391 -0.0293 0.4792 0.8309 0.3702 ...
##  $ guiltcat: int  2 2 3 3 2 1 1 1 2 4 ...
```

```r
summary(d0)
```

```
##      guilt         mentill        futhrt           se        
##  Min.   :1.00   Min.   :0.0   Min.   :0.00   Min.   :0.0518  
##  1st Qu.:1.00   1st Qu.:0.0   1st Qu.:3.00   1st Qu.:0.0518  
##  Median :2.00   Median :0.5   Median :4.00   Median :0.0518  
##  Mean   :2.04   Mean   :0.5   Mean   :4.03   Mean   :0.0518  
##  3rd Qu.:3.00   3rd Qu.:1.0   3rd Qu.:5.00   3rd Qu.:0.0518  
##  Max.   :3.00   Max.   :1.0   Max.   :9.00   Max.   :0.0518  
##        z              pp             futthcat        guiltq      
##  Min.   :2.51   Min.   :0.00598   Min.   :2.00   Min.   :-1.607  
##  1st Qu.:2.51   1st Qu.:0.00598   1st Qu.:3.00   1st Qu.:-0.187  
##  Median :2.51   Median :0.00598   Median :4.00   Median : 0.420  
##  Mean   :2.51   Mean   :0.00598   Mean   :3.95   Mean   : 0.416  
##  3rd Qu.:2.51   3rd Qu.:0.00598   3rd Qu.:5.00   3rd Qu.: 0.949  
##  Max.   :2.51   Max.   :0.00598   Max.   :6.00   Max.   : 2.524  
##     guiltcat   
##  Min.   :1.00  
##  1st Qu.:1.75  
##  Median :3.00  
##  Mean   :2.50  
##  3rd Qu.:3.00  
##  Max.   :4.00
```


### Factoring categorical variables
After we've loaded in the data, we should always check which variables we might need to factor. Here, we'll start by factoring mental illness, since the defendants fall into one of two discrete categories; normal (not mentally ill), or mentally ill.


```r
d0$mentill = factor(d0$mentill, label = c("Normal", "Mentally Ill"))
str(d0)
```

```
## 'data.frame':	240 obs. of  9 variables:
##  $ guilt   : int  1 1 1 1 1 1 1 1 1 1 ...
##  $ mentill : Factor w/ 2 levels "Normal","Mentally Ill": 2 2 2 2 2 2 2 2 2 2 ...
##  $ futhrt  : int  4 3 8 5 6 7 3 3 4 4 ...
##  $ se      : num  0.0518 0.0518 0.0518 0.0518 0.0518 ...
##  $ z       : num  2.51 2.51 2.51 2.51 2.51 ...
##  $ pp      : num  0.00599 0.00599 0.00599 0.00599 0.00599 ...
##  $ futthcat: int  4 3 6 5 6 6 3 3 4 4 ...
##  $ guiltq  : num  0.3391 -0.0293 0.4792 0.8309 0.3702 ...
##  $ guiltcat: int  2 2 3 3 2 1 1 1 2 4 ...
```


Visualize data
-------------
It's always a good idea to see what trends might exist in your data; this will be helpful later on, when interpreting possible interactions, etc.

Simplest plot:


```r
with(d0, plot(mentill, futhrt))
```

![plot of chunk simple boxplots](figure/simple_boxplots.png) 



```r
library(ggplot2)

ggplot(d0, aes(x = mentill, y = futhrt)) + geom_boxplot() + stat_summary(fun.y = mean, 
    geom = "point", shape = 5, size = 4)
```

![plot of chunk ggplot](figure/ggplot1.png) 

```r

ggplot(d0, aes(x = futhrt, y = guilt, color = mentill)) + geom_point(shape = 1, 
    position = position_jitter(width = 0.25, height = 0.25)) + geom_smooth(method = lm, 
    fullrange = TRUE)
```

![plot of chunk ggplot](figure/ggplot2.png) 


Generate Hypotheses
-------------------
How does perceived **mental illness** of the defendant influence how much the participant thinks the defendant will be a **future threat**?

Possible explanations?
1. If a person is mentally ill, they might cause a lot of harm to society, but not necessarily know why; they might be worse at controlling their actions.
2. A person who is not mentall ill might commit specific crimes against people they know (e.g., if someone found out their significant other was cheating on them, they might harm the person who was cheating), and thus not pose as big a threat to everyone in society.


```r
str(d0)
```

```
## 'data.frame':	240 obs. of  9 variables:
##  $ guilt   : int  1 1 1 1 1 1 1 1 1 1 ...
##  $ mentill : Factor w/ 2 levels "Normal","Mentally Ill": 2 2 2 2 2 2 2 2 2 2 ...
##  $ futhrt  : int  4 3 8 5 6 7 3 3 4 4 ...
##  $ se      : num  0.0518 0.0518 0.0518 0.0518 0.0518 ...
##  $ z       : num  2.51 2.51 2.51 2.51 2.51 ...
##  $ pp      : num  0.00599 0.00599 0.00599 0.00599 0.00599 ...
##  $ futthcat: int  4 3 6 5 6 6 3 3 4 4 ...
##  $ guiltq  : num  0.3391 -0.0293 0.4792 0.8309 0.3702 ...
##  $ guiltcat: int  2 2 3 3 2 1 1 1 2 4 ...
```

```r
levels(d0$mentill)
```

```
## [1] "Normal"       "Mentally Ill"
```

```r

# get some summary stats
library(psych)
```

```
## Attaching package: 'psych'
## 
## The following object is masked from 'package:ggplot2':
## 
## %+%
```

```r
describeBy(d0$futhrt, group = d0$mentill, mat = TRUE)
```

```
##    item       group1 var   n  mean    sd median trimmed   mad min max
## 11    1       Normal   1 120 3.633 1.495      3   3.542 1.483   0   8
## 12    2 Mentally Ill   1 120 4.433 1.586      4   4.333 1.483   0   9
##    range   skew kurtosis     se
## 11     8 0.5449   0.6489 0.1364
## 12     9 0.4027  -0.0867 0.1448
```

```r

# another way to get some quick stats:
library(plyr)
ddply(d0, ~mentill, summarise, mean = mean(futhrt), sd = sd(futhrt), n = length(futhrt))
```

```
##        mentill  mean    sd   n
## 1       Normal 3.633 1.495 120
## 2 Mentally Ill 4.433 1.586 120
```


Here, we can see that **mental illness** is *categorical*; it has the value of "not mentally ill/normal" or "mentally ill". Perceived **future threat** is continuous, since participants rated this variable on a scale.

By looking at the summary statistics, we can see that the mean perceived future threat for normal people = 3.633, and the mean perceived threat for mentally ill people = 4.433.

Testing Hypotheses
-------------------
Does perceived **mental illness** of the defendant influence how much the participant thinks the defendant will be a **future threat**?

To test this, we could use an unpaired t-test (since there are only two groups), or a general linear model (i.e., `lm()`). The results should be the same in either case.

First, let's use a t-test:

```r
# are the variances in futhrt equal between mental illness groups?
bartlett.test(futhrt ~ mentill, data = d0)
```

```
## 
## 	Bartlett test of homogeneity of variances
## 
## data:  futhrt by mentill
## Bartlett's K-squared = 0.4193, df = 1, p-value = 0.5173
```

```r

`?`(t.test)
t1 <- t.test(futhrt ~ mentill, data = d0, paired = FALSE, var.equal = TRUE)
print(t1)
```

```
## 
## 	Two Sample t-test
## 
## data:  futhrt by mentill
## t = -4.021, df = 238, p-value = 7.792e-05
## alternative hypothesis: true difference in means is not equal to 0
## 95 percent confidence interval:
##  -1.192 -0.408
## sample estimates:
##       mean in group Normal mean in group Mentally Ill 
##                      3.633                      4.433
```

```r

## compare to paired
t.test(futhrt ~ mentill, data = d0, paired = TRUE, var.equal = TRUE)
```

```
## 
## 	Paired t-test
## 
## data:  futhrt by mentill
## t = -4.043, df = 119, p-value = 9.414e-05
## alternative hypothesis: true difference in means is not equal to 0
## 95 percent confidence interval:
##  -1.1918 -0.4082
## sample estimates:
## mean of the differences 
##                    -0.8
```


Now, let's test this same question using a general linear model:

```r
rs1 = lm(futhrt ~ mentill, data = d0)
summary(rs1)
```

```
## 
## Call:
## lm(formula = futhrt ~ mentill, data = d0)
## 
## Residuals:
##    Min     1Q Median     3Q    Max 
## -4.433 -1.433 -0.433  0.767  4.567 
## 
## Coefficients:
##                     Estimate Std. Error t value Pr(>|t|)    
## (Intercept)            3.633      0.141   25.82  < 2e-16 ***
## mentillMentally Ill    0.800      0.199    4.02  7.8e-05 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 1.54 on 238 degrees of freedom
## Multiple R-squared:  0.0636,	Adjusted R-squared:  0.0597 
## F-statistic: 16.2 on 1 and 238 DF,  p-value: 7.79e-05
```

```r
anova(rs1)
```

```
## Analysis of Variance Table
## 
## Response: futhrt
##            Df Sum Sq Mean Sq F value  Pr(>F)    
## mentill     1     38    38.4    16.2 7.8e-05 ***
## Residuals 238    565     2.4                    
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
```

```r

(t1$statistic)^2  # Remember that t ^ 2 is approximately equal to F!
```

```
##     t 
## 16.17
```


Here, we can see that the anova() output is identical to the t-test we ran above. However, we get some more information when looking at the lm() output. Here, the estimate for the intercept (i.e., `3.633`) gives us the `y-intercept` for our model; this is the value of `futhrt` where `mentill` = 0. In other words, this is the mean value of `futhrt` for the *control* group of `mentill`. That is, since mental illness is categorical, `lm()` automatically **dummy-codes** the variable. That means that one condition is treated as a "control" (and coded as 0), and the other condition(s) are compared to that control via the dummy-coding. 

To get a sense for this, let's take a look at the default dummy contrasts:
### Contrasts

```r
contrasts(d0$mentill)
```

```
##              Mentally Ill
## Normal                  0
## Mentally Ill            1
```


We can see that the column `Mentally Ill` gives `Normal` a value of 0, and `Mentally Ill` a value of 1. As a result, the `Normal` level of `mentill` is treated as the control, and the `lm()` will compare the level `Mentally Ill` to the `Normal` level.

As we can see from the output of the `lm()`, the **intercept estimate gives us the mean value of future threat for the Normal condition**. 

In addition the `mentillMentally Ill` estimate is giving us the results from the first column of our contrasts for `mentill` (in this case, our *only* column), that is called `Mentally Ill`. The `estimate` for this contrast is basically the difference between the mean futhrt of our `Mentally Ill` group, relative to our `Normal` group. Thus, we can derive the **mean value of future threat for the Mentally Ill condition by adding the estimate (i.e., slope) to the intercept; this gives us 3.633 + 0.800 = 4.433, the mean perceived future threat for the Mentally Ill group.**


```r
mean(d0$futhrt[d0$mentill == "Mentally Ill"])
```

```
## [1] 4.433
```


More complicated questions (testing the relationship between multiple variables)
-------------------------------------------------

Now let's take a look at a more complicated model.  What would we expect if we looked at whether mental illness and perceptions of being a future threat predict judgments of guilt?  Would we predict main effects?  Interactions?

Mental illness: Categorical IV
Future threat: Continuous IV

Guilt: Continuous DV
(1 = Definitely Not Guilty, 2 = Probably Not Guilty, 3 = Probably Guilty, or 4 = Definitely Guilty)

Let's start out with the simplest model.

```r

m1 = lm(guilt ~ futhrt, d0)  # What kind of test is this?
summary(m1)
```

```
## 
## Call:
## lm(formula = guilt ~ futhrt, data = d0)
## 
## Residuals:
##     Min      1Q  Median      3Q     Max 
## -1.4468 -0.9361  0.0639  0.8596  1.1660 
## 
## Coefficients:
##             Estimate Std. Error t value Pr(>|t|)    
## (Intercept)   1.6297     0.1461   11.15   <2e-16 ***
## futhrt        0.1021     0.0337    3.03   0.0027 ** 
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 0.828 on 238 degrees of freedom
## Multiple R-squared:  0.0371,	Adjusted R-squared:  0.0331 
## F-statistic: 9.18 on 1 and 238 DF,  p-value: 0.00272
```


Seems like as judges perceive a target to be a greater future threat, they are more likely to think the defendant is guilty. Let's explore some different ways to plot this.


```r

with(d0, plot(futhrt, guilt))
lines(abline(m1, col='green'))
```

![plot of chunk plotting options](figure/plotting_options1.png) 

```r

ggplot(d0, aes(x=futhrt, y=guilt)) + 
  geom_point(shape=1) +  # Use hollow circles
  geom_smooth(method=lm, fullrange=TRUE) # Add linear regression line 
```

![plot of chunk plotting options](figure/plotting_options2.png) 

```r
                         #  (by default includes 95% confidence region, to remove
                         #   use se=FALSE)

ggplot(d0, aes(x=futhrt, y=guilt)) + 
  geom_point(shape=1, position=position_jitter(width=.5,height=.25)) +  
  geom_smooth(method=lm, fullrange=TRUE)
```

![plot of chunk plotting options](figure/plotting_options3.png) 


Let's move on to a more complicated model.


```r

m2 = lm(guilt ~ futhrt + mentill, d0)
summary(m2)
```

```
## 
## Call:
## lm(formula = guilt ~ futhrt + mentill, data = d0)
## 
## Residuals:
##     Min      1Q  Median      3Q     Max 
## -1.4988 -0.5745 -0.0442  0.6528  1.5771 
## 
## Coefficients:
##                     Estimate Std. Error t value Pr(>|t|)    
## (Intercept)           1.7411     0.1376   12.65  < 2e-16 ***
## futhrt                0.1515     0.0325    4.66  5.2e-06 ***
## mentillMentally Ill  -0.6212     0.1031   -6.02  6.4e-09 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 0.773 on 237 degrees of freedom
## Multiple R-squared:  0.165,	Adjusted R-squared:  0.158 
## F-statistic: 23.4 on 2 and 237 DF,  p-value: 5.25e-10
```


What kind of model is this? 
Additive!

What would we conclude from this output? 


```r

qplot(x = futhrt, y = guilt, data = d0, geom = c("jitter", "smooth"), method = "lm", 
    se = FALSE, color = mentill, main = "Predictors of Perceived Guilt", xlab = "Future Threat", 
    ylab = "Guilt")
```

![plot of chunk qplot](figure/qplot.png) 


What does it look like is going on in this plot?

Let's check out a more complicated model


```r

m3 = lm(guilt ~ futhrt * mentill, d0)
summary(m3)
```

```
## 
## Call:
## lm(formula = guilt ~ futhrt * mentill, data = d0)
## 
## Residuals:
##     Min      1Q  Median      3Q     Max 
## -1.6044 -0.6728  0.0802  0.6244  1.4101 
## 
## Coefficients:
##                            Estimate Std. Error t value Pr(>|t|)    
## (Intercept)                  1.4603     0.1845    7.91  9.7e-14 ***
## futhrt                       0.2288     0.0470    4.87  2.1e-06 ***
## mentillMentally Ill         -0.0363     0.2784   -0.13    0.896    
## futhrt:mentillMentally Ill  -0.1459     0.0646   -2.26    0.025 *  
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 0.766 on 236 degrees of freedom
## Multiple R-squared:  0.183,	Adjusted R-squared:  0.172 
## F-statistic: 17.6 on 3 and 236 DF,  p-value: 2.46e-10
```


What would we conclude from this output?


```r

with(d0, interaction.plot(futhrt, mentill, guilt, col = 2:3))  # Not the best, plotting mean for each value of the continuous variable "futhrt" 
```

![plot of chunk plots](figure/plots1.png) 

```r

ggplot(d0, aes(x=futhrt, y=guilt, colour=mentill)) +  # Adding color for mentill
  geom_point(shape=1, position=position_jitter(width=1,height=.5)) +  
  geom_smooth(method=lm, se=FALSE) +
  theme_bw()
```

![plot of chunk plots](figure/plots2.png) 


Let's center this model!


```r
m5c = lm(guilt~ I(futhrt - mean(futhrt)) * mentill, d0)
summary(m5c)
```

```
## 
## Call:
## lm(formula = guilt ~ I(futhrt - mean(futhrt)) * mentill, data = d0)
## 
## Residuals:
##     Min      1Q  Median      3Q     Max 
## -1.6044 -0.6728  0.0802  0.6244  1.4101 
## 
## Coefficients:
##                                              Estimate Std. Error t value
## (Intercept)                                    2.3832     0.0724   32.90
## I(futhrt - mean(futhrt))                       0.2288     0.0470    4.87
## mentillMentally Ill                           -0.6247     0.1023   -6.11
## I(futhrt - mean(futhrt)):mentillMentally Ill  -0.1459     0.0646   -2.26
##                                              Pr(>|t|)    
## (Intercept)                                   < 2e-16 ***
## I(futhrt - mean(futhrt))                      2.1e-06 ***
## mentillMentally Ill                           4.1e-09 ***
## I(futhrt - mean(futhrt)):mentillMentally Ill    0.025 *  
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 0.766 on 236 degrees of freedom
## Multiple R-squared:  0.183,	Adjusted R-squared:  0.172 
## F-statistic: 17.6 on 3 and 236 DF,  p-value: 2.46e-10
```

```r

ggplot(d0, aes(x=scale(futhrt), y=guilt, colour=mentill)) +  # Adding color for mentill
  geom_point(shape=1, position=position_jitter(width=1,height=.5)) +  
  geom_smooth(method=lm, se=FALSE) +
  theme_bw()
```

![plot of chunk unnamed-chunk-10](figure/unnamed-chunk-10.png) 


Note what changed in the coefficients - why would this have changed?

Now let's explore whether there is a quadratic relationship in our data.


```r

m4 = lm(guilt ~ poly(futhrt, 2) + mentill, d0)
summary(m4)
```

```
## 
## Call:
## lm(formula = guilt ~ poly(futhrt, 2) + mentill, data = d0)
## 
## Residuals:
##     Min      1Q  Median      3Q     Max 
## -1.5672 -0.5875  0.0386  0.5801  1.6691 
## 
## Coefficients:
##                     Estimate Std. Error t value Pr(>|t|)    
## (Intercept)           2.3569     0.0714   33.03  < 2e-16 ***
## poly(futhrt, 2)1      3.7415     0.7941    4.71  4.2e-06 ***
## poly(futhrt, 2)2     -1.5108     0.7692   -1.96    0.051 .  
## mentillMentally Ill  -0.6305     0.1026   -6.14  3.4e-09 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 0.768 on 236 degrees of freedom
## Multiple R-squared:  0.178,	Adjusted R-squared:  0.168 
## F-statistic: 17.1 on 3 and 236 DF,  p-value: 4.48e-10
```


How might we plot this?


```r

ggplot(d0, aes(x = futhrt, y = guilt, colour = mentill)) + geom_point(shape = 1, 
    position = position_jitter(width = 1, height = 0.5)) + geom_smooth(method = "loess", 
    se = FALSE)  # remove 'method=lm', loess smooth fit curve!
```

![plot of chunk loess](figure/loess.png) 


Interactive model


```r

m5 = lm(guilt ~ poly(futhrt, 2) * mentill, d0)
summary(m5)
```

```
## 
## Call:
## lm(formula = guilt ~ poly(futhrt, 2) * mentill, data = d0)
## 
## Residuals:
##     Min      1Q  Median      3Q     Max 
## -1.6102 -0.6554  0.0835  0.6150  1.5903 
## 
## Coefficients:
##                                      Estimate Std. Error t value Pr(>|t|)
## (Intercept)                            2.3827     0.0723   32.94  < 2e-16
## poly(futhrt, 2)1                       5.5515     1.2081    4.60  7.1e-06
## poly(futhrt, 2)2                      -0.2184     1.1220   -0.19    0.846
## mentillMentally Ill                   -0.6400     0.1025   -6.25  2.0e-09
## poly(futhrt, 2)1:mentillMentally Ill  -2.8967     1.6631   -1.74    0.083
## poly(futhrt, 2)2:mentillMentally Ill  -1.7748     1.6088   -1.10    0.271
##                                         
## (Intercept)                          ***
## poly(futhrt, 2)1                     ***
## poly(futhrt, 2)2                        
## mentillMentally Ill                  ***
## poly(futhrt, 2)1:mentillMentally Ill .  
## poly(futhrt, 2)2:mentillMentally Ill    
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 0.765 on 234 degrees of freedom
## Multiple R-squared:  0.193,	Adjusted R-squared:  0.176 
## F-statistic: 11.2 on 5 and 234 DF,  p-value: 1.08e-09
```


So how do we decide which model is best?


```r

anova(m1, m2, m3)  # why wouldn't we compare m4?
```

```
## Analysis of Variance Table
## 
## Model 1: guilt ~ futhrt
## Model 2: guilt ~ futhrt + mentill
## Model 3: guilt ~ futhrt * mentill
##   Res.Df RSS Df Sum of Sq    F  Pr(>F)    
## 1    238 163                              
## 2    237 142  1      21.7 36.9 4.9e-09 ***
## 3    236 139  1       3.0  5.1   0.025 *  
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
```

```r

anova(m3, m4)
```

```
## Analysis of Variance Table
## 
## Model 1: guilt ~ futhrt * mentill
## Model 2: guilt ~ poly(futhrt, 2) + mentill
##   Res.Df RSS Df Sum of Sq F Pr(>F)
## 1    236 139                      
## 2    236 139  0     -0.72
```

```r

m4a <- lm(guilt ~ poly(futhrt, 2), d0)
anova(m1, m4a, m4)
```

```
## Analysis of Variance Table
## 
## Model 1: guilt ~ futhrt
## Model 2: guilt ~ poly(futhrt, 2)
## Model 3: guilt ~ poly(futhrt, 2) + mentill
##   Res.Df RSS Df Sum of Sq     F  Pr(>F)    
## 1    238 163                               
## 2    237 162  1      1.67  2.83   0.094 .  
## 3    236 139  1     22.29 37.76 3.4e-09 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
```

```r

anova(m2, m4)
```

```
## Analysis of Variance Table
## 
## Model 1: guilt ~ futhrt + mentill
## Model 2: guilt ~ poly(futhrt, 2) + mentill
##   Res.Df RSS Df Sum of Sq    F Pr(>F)  
## 1    237 142                           
## 2    236 139  1      2.28 3.86  0.051 .
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
```



```r

anova(m4, m5)
```

```
## Analysis of Variance Table
## 
## Model 1: guilt ~ poly(futhrt, 2) + mentill
## Model 2: guilt ~ poly(futhrt, 2) * mentill
##   Res.Df RSS Df Sum of Sq    F Pr(>F)
## 1    236 139                         
## 2    234 137  2      2.49 2.13   0.12
```


Which model would we use?
