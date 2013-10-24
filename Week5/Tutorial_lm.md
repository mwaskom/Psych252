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


Or, you can use the ggplot2 package:

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
 1.   If a person is mentally ill, they might cause a lot of harm to society, but not necessarily know why; they might be worse at controlling their actions.
 2.   A person who is not mentally ill might commit specific crimes against people they know (e.g., if someone found out their significant other was cheating on them, they might harm the person who was cheating), and thus not pose as big a threat to everyone in society.


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

By looking at the summary statistics, we can see that the mean perceived future threat for normal people = `3.633`, and the mean perceived threat for mentally ill people = `4.433`.


Testing Hypotheses
-------------------
Does perceived **mental illness** of the defendant influence how much the participant thinks the defendant will be a **future threat**?

To test this, we could use an unpaired t-test (since there are only two groups), or a general linear model (i.e., `lm()`). The results should be the same in either case.

First, let's use a t-test (make sure we specify `paired=FALSE` since different subjects read different stories!):

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
t1 = t.test(futhrt ~ mentill, data = d0, paired = FALSE, var.equal = TRUE)
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


Here, we can see that the anova() output is **identical to the t-test** we ran above. However, we get some more information when looking at the lm() output. 

### Interpreting the Intercept from `lm()`
The estimate for the intercept (i.e., `3.633`) gives us the `y-intercept` for our model; in this example, the y-intercept is the value of `futhrt` where `mentill` = 0. Importantly, when using R's default coding, this y-intercept value is the mean value of `futhrt` for the *control* group of `mentill`. That is, since mental illness is categorical, `lm()` automatically **dummy-codes** the variable; that means that one condition is treated as a **"control" (and coded as 0)**, and the other condition(s) are compared to that control via the dummy-coding. 

To get a sense for this, let's take a look at the default dummy contrasts:
### Dummy coding contrasts

```r
contrasts(d0$mentill)
```

```
##              Mentally Ill
## Normal                  0
## Mentally Ill            1
```


We can see that the column `Mentally Ill` gives `Normal` a value of 0, and `Mentally Ill` a value of 1. As a result, the `Normal` level of `mentill` is treated as the control, and the `lm()` will compare the level `Mentally Ill` to the `Normal` level.

As we can see from the output of the `lm()`, the **intercept estimate gives us the mean value of future threat for the Normal (i.e., "control") condition**. 

### Interpreting the estimates/coefficients/slopes
Further, the `mentillMentally Ill` estimate in our `lm()` output gives us the results from the column of our contrasts for `mentill` (in this case, our *only* column), that is called `Mentally Ill`. R uses the format `variableConstrastName` to label each contrast, and these contrasts are what appear in the `lm()` output. By default, the 2nd level of the variable will become the first contrast (and 3rd level the 2nd contrast, etc.).

In the `lm()` output, the `estimate` for this contrast is basically the difference between the mean `futhrt` of our `Mentally Ill` group, relative to our `Normal` group. Thus, we can derive the **mean value of future threat for the Mentally Ill condition by adding the estimate (i.e., slope) to the intercept; this gives us 3.633 + 0.800 = 4.433, the mean perceived future threat for the Mentally Ill group.**


```r
# adding the intercept + the estimate/slope of 'Mentally Ill'
rs1$coefficients[1] + rs1$coefficients[2]
```

```
## (Intercept) 
##       4.433
```

```r

# calculating the mean of mentally ill
mean(d0$futhrt[d0$mentill == "Mentally Ill"])
```

```
## [1] 4.433
```



More complicated questions (testing the relationship between multiple variables)
-------------------------------------------------
One nice thing about general linear models is that you can explore more complicated relationships between variables. For instance, what if you wanted to know how **perceptions of future threat** (a *continuous* variable) and **mental illness** (a *categorical* variable) influence the **judgment of guilt** (a *continuous* variable)?

Is there a **main effect** of mental illness, such that someone perceived as mentally ill is considered less guilty? Is there a **main effect** of perception of future threat, such that those with a higher level of perceived future threat are considered more guilty? Is there an **additive** effect of mental illness and future threat, such that one level of mental illness results in higher levels of guilt across all levels of perceived future threat? Or, might there be an **interaction**, such that whether or not a person is perceived as mentally ill influences the relationship between perceived future threat on judgements of guilt? In the case of an interaction, it might be the case that for mentally ill people, the perceived future threat of a defendant doesn't have much effect on the guilt of the defendant. However, for normal people, whether or not someone is a perceived future threat might have a large impact on their perceived guilt.

### Single term model
Let's start out with a simple model:

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


Seems like as people perceive the defendant to be a greater future threat, they are more likely to think the defendant is guilty.


```r
ggplot(d0, aes(x = futhrt, y = guilt)) + geom_point(shape = 1, position = position_jitter(width = 0.3, 
    height = 0.3)) + geom_smooth(method = lm, fullrange = TRUE)
```

![plot of chunk plotting options ](figure/plotting_options_.png) 

However, we can see that the intercept here does not give us the mean value of guilt, i.e., the value of guilt at the mean value of future threat.

### CENTERING continuous variables (i.e., future threat):

```r
m1_centered = lm(guilt ~ scale(futhrt, scale = FALSE), d0)  # What kind of test is this?
summary(m1_centered)
```

```
## 
## Call:
## lm(formula = guilt ~ scale(futhrt, scale = FALSE), data = d0)
## 
## Residuals:
##     Min      1Q  Median      3Q     Max 
## -1.4468 -0.9361  0.0639  0.8596  1.1660 
## 
## Coefficients:
##                              Estimate Std. Error t value Pr(>|t|)    
## (Intercept)                    2.0417     0.0535   38.19   <2e-16 ***
## scale(futhrt, scale = FALSE)   0.1021     0.0337    3.03   0.0027 ** 
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 0.828 on 238 degrees of freedom
## Multiple R-squared:  0.0371,	Adjusted R-squared:  0.0331 
## F-statistic: 9.18 on 1 and 238 DF,  p-value: 0.00272
```

```r

# mean value of guilt
mean(d0$guilt)
```

```
## [1] 2.042
```

Here, we can see that the results are essentially the same as what we saw with the uncentered version of `futhrt`, however, when we center, our intercept is more informative.

### Additive model
Let's move on to a more complicated **ADDITIVE** model.

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

What kind of model is this? Additive!

Now, let's see what happens when we center `futhrt`:

```r
m2_centered = lm(guilt ~ scale(futhrt, scale = FALSE) + mentill, d0)
summary(m2_centered)
```

```
## 
## Call:
## lm(formula = guilt ~ scale(futhrt, scale = FALSE) + mentill, 
##     data = d0)
## 
## Residuals:
##     Min      1Q  Median      3Q     Max 
## -1.4988 -0.5745 -0.0442  0.6528  1.5771 
## 
## Coefficients:
##                              Estimate Std. Error t value Pr(>|t|)    
## (Intercept)                    2.3523     0.0718   32.78  < 2e-16 ***
## scale(futhrt, scale = FALSE)   0.1515     0.0325    4.66  5.2e-06 ***
## mentillMentally Ill           -0.6212     0.1031   -6.02  6.4e-09 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 0.773 on 237 degrees of freedom
## Multiple R-squared:  0.165,	Adjusted R-squared:  0.158 
## F-statistic: 23.4 on 2 and 237 DF,  p-value: 5.25e-10
```

```r

# approximate interpretation of the intercept:
mean(d0$guilt[d0$mentill == "Normal"])
```

```
## [1] 2.292
```

Again, we can see most of the results stay the same, but the intercept changes. Now, the intercept is the mean level of `guilt` where `futhrt` = 0 (i.e., the mean of future threat), and where `mentill` = 0 (i.e., for Normal people).

What would we conclude from this output? 

```r
qplot(x = futhrt, y = guilt, data = d0, geom = c("jitter", "smooth"), method = "lm", 
    se = FALSE, color = mentill, main = "Predictors of Perceived Guilt", xlab = "Future Threat", 
    ylab = "Guilt")
```

![plot of chunk q](figure/q.png) 

What does it look like is going on in this plot?

### Interactive model
Let's check out a more complicated **INTERACTIVE** model:

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

This model is looking at the effect of mental illness where future threat is = 0, the effect of future threat where mental illness = 0 (i.e., for normal people), and the interaction of these two variables.

Now, again let's try **centering** `futhrt`:

```r
m3_centered = lm(guilt ~ scale(futhrt, scale = FALSE) * mentill, d0)
summary(m3_centered)
```

```
## 
## Call:
## lm(formula = guilt ~ scale(futhrt, scale = FALSE) * mentill, 
##     data = d0)
## 
## Residuals:
##     Min      1Q  Median      3Q     Max 
## -1.6044 -0.6728  0.0802  0.6244  1.4101 
## 
## Coefficients:
##                                                  Estimate Std. Error
## (Intercept)                                        2.3832     0.0724
## scale(futhrt, scale = FALSE)                       0.2288     0.0470
## mentillMentally Ill                               -0.6247     0.1023
## scale(futhrt, scale = FALSE):mentillMentally Ill  -0.1459     0.0646
##                                                  t value Pr(>|t|)    
## (Intercept)                                        32.90  < 2e-16 ***
## scale(futhrt, scale = FALSE)                        4.87  2.1e-06 ***
## mentillMentally Ill                                -6.11  4.1e-09 ***
## scale(futhrt, scale = FALSE):mentillMentally Ill   -2.26    0.025 *  
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 0.766 on 236 degrees of freedom
## Multiple R-squared:  0.183,	Adjusted R-squared:  0.172 
## F-statistic: 17.6 on 3 and 236 DF,  p-value: 2.46e-10
```

When we center, first note that our *interaction term stays the same*. However, whereas before the effect of mental illness wasn't significant, now it is. This is because now we are looking at the effect of mental illness where future threat is equal to 0, where future threat = 0 is the mean value of future threat. 

However, this model centering `futhrt` is looking at the effect of future threat where `mentill` = 0. In order to look at the **main effect** of future threat, we need to also center `mentill`. One way we can do this is with **effect coding**.

### Effect Coding

```r
# Effect code mentill
contrasts(d0$mentill) = c(1, -1)
contrasts(d0$mentill)
```

```
##              [,1]
## Normal          1
## Mentally Ill   -1
```

```r

m3_centered_fmentill = lm(guilt ~ scale(futhrt, scale = FALSE) * mentill, d0)
summary(m3_centered_fmentill)
```

```
## 
## Call:
## lm(formula = guilt ~ scale(futhrt, scale = FALSE) * mentill, 
##     data = d0)
## 
## Residuals:
##     Min      1Q  Median      3Q     Max 
## -1.6044 -0.6728  0.0802  0.6244  1.4101 
## 
## Coefficients:
##                                       Estimate Std. Error t value Pr(>|t|)
## (Intercept)                             2.0708     0.0511   40.50  < 2e-16
## scale(futhrt, scale = FALSE)            0.1559     0.0323    4.83  2.5e-06
## mentill1                                0.3123     0.0511    6.11  4.1e-09
## scale(futhrt, scale = FALSE):mentill1   0.0729     0.0323    2.26    0.025
##                                          
## (Intercept)                           ***
## scale(futhrt, scale = FALSE)          ***
## mentill1                              ***
## scale(futhrt, scale = FALSE):mentill1 *  
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 0.766 on 236 degrees of freedom
## Multiple R-squared:  0.183,	Adjusted R-squared:  0.172 
## F-statistic: 17.6 on 3 and 236 DF,  p-value: 2.46e-10
```

Now, these results show us the main effect of future threat, the main effect of mental illness, and the interaction.


Let's visualize the centered model:

```r
ggplot(d0, 
       aes(x=scale(futhrt, scale=FALSE), 
           y=guilt, colour=mentill)) +  # Adding color for mentill
  geom_point(shape=1, position=position_jitter(width=1,height=.5)) +  
  geom_smooth(method=lm, se=FALSE) +
  theme_bw()
```

![plot of chunk unnamed-chunk-14](figure/unnamed-chunk-14.png) 




### Non-linear trends (quadratic relationships)
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
##                  Estimate Std. Error t value Pr(>|t|)    
## (Intercept)        2.0417     0.0496   41.17  < 2e-16 ***
## poly(futhrt, 2)1   3.7415     0.7941    4.71  4.2e-06 ***
## poly(futhrt, 2)2  -1.5108     0.7692   -1.96    0.051 .  
## mentill1           0.3153     0.0513    6.14  3.4e-09 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 0.768 on 236 degrees of freedom
## Multiple R-squared:  0.178,	Adjusted R-squared:  0.168 
## F-statistic: 17.1 on 3 and 236 DF,  p-value: 4.48e-10
```


How might we plot this?

```r
ggplot(d0, aes(x = scale(futhrt, scale = FALSE), y = guilt, colour = mentill)) + 
    geom_point(shape = 1, position = position_jitter(width = 1, height = 0.5)) + 
    geom_smooth(method = "loess", se = FALSE)  # remove 'method=lm', loess smooth fit curve!
```

![plot of chunk loess ](figure/loess_.png) 

Using **"loess"** as a smoothing term fits a locally weighted line to the data, and thus might help highlight non-linear trends.


Now let's add an interactive term to test an **interactive, quadratic** model:

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
##                           Estimate Std. Error t value Pr(>|t|)    
## (Intercept)                 2.0627     0.0512   40.26  < 2e-16 ***
## poly(futhrt, 2)1            4.1032     0.8315    4.93  1.5e-06 ***
## poly(futhrt, 2)2           -1.1058     0.8044   -1.37    0.171    
## mentill1                    0.3200     0.0512    6.25  2.0e-09 ***
## poly(futhrt, 2)1:mentill1   1.4483     0.8315    1.74    0.083 .  
## poly(futhrt, 2)2:mentill1   0.8874     0.8044    1.10    0.271    
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 0.765 on 234 degrees of freedom
## Multiple R-squared:  0.193,	Adjusted R-squared:  0.176 
## F-statistic: 11.2 on 5 and 234 DF,  p-value: 1.08e-09
```



### Model comparison (picking the best model)
So how do we decide which model is best?

```r

# linear models
anova(m1, m2_centered, m3_centered)  # why wouldn't we compare m4?
```

```
## Analysis of Variance Table
## 
## Model 1: guilt ~ futhrt
## Model 2: guilt ~ scale(futhrt, scale = FALSE) + mentill
## Model 3: guilt ~ scale(futhrt, scale = FALSE) * mentill
##   Res.Df RSS Df Sum of Sq    F  Pr(>F)    
## 1    238 163                              
## 2    237 142  1      21.7 36.9 4.9e-09 ***
## 3    236 139  1       3.0  5.1   0.025 *  
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
```

```r

# addition of quadratic trend
anova(m3_centered, m4)
```

```
## Analysis of Variance Table
## 
## Model 1: guilt ~ scale(futhrt, scale = FALSE) * mentill
## Model 2: guilt ~ poly(futhrt, 2) + mentill
##   Res.Df RSS Df Sum of Sq F Pr(>F)
## 1    236 139                      
## 2    236 139  0     -0.72
```

```r

# addition of quadratic trend to additive model
anova(m2_centered, m4)
```

```
## Analysis of Variance Table
## 
## Model 1: guilt ~ scale(futhrt, scale = FALSE) + mentill
## Model 2: guilt ~ poly(futhrt, 2) + mentill
##   Res.Df RSS Df Sum of Sq    F Pr(>F)  
## 1    237 142                           
## 2    236 139  1      2.28 3.86  0.051 .
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
```

```r

# addition of quadratic trend to interactive model
anova(m3_centered, m5)
```

```
## Analysis of Variance Table
## 
## Model 1: guilt ~ scale(futhrt, scale = FALSE) * mentill
## Model 2: guilt ~ poly(futhrt, 2) * mentill
##   Res.Df RSS Df Sum of Sq    F Pr(>F)
## 1    236 139                         
## 2    234 137  2      1.77 1.51   0.22
```

Which model would we use?




Continuous Interations
------------------------

First let's start by loading in some generic R data

```r
library(MASS)
data(state)
state = data.frame(state.x77)
str(state)
```

```
## 'data.frame':	50 obs. of  8 variables:
##  $ Population: num  3615 365 2212 2110 21198 ...
##  $ Income    : num  3624 6315 4530 3378 5114 ...
##  $ Illiteracy: num  2.1 1.5 1.8 1.9 1.1 0.7 1.1 0.9 1.3 2 ...
##  $ Life.Exp  : num  69 69.3 70.5 70.7 71.7 ...
##  $ Murder    : num  15.1 11.3 7.8 10.1 10.3 6.8 3.1 6.2 10.7 13.9 ...
##  $ HS.Grad   : num  41.3 66.7 58.1 39.9 62.6 63.9 56 54.6 52.6 40.6 ...
##  $ Frost     : num  20 152 15 65 20 166 139 103 11 60 ...
##  $ Area      : num  50708 566432 113417 51945 156361 ...
```


What is the effect of Illiteracy on Income?

```r
ggplot(state, 
       aes(x=scale(Illiteracy, scale=FALSE), 
           y=Income)) +  # Adding color for mentill
  geom_point(shape=1) +  
  geom_smooth(method=lm) +
  theme_bw()
```

![plot of chunk unnamed-chunk-16](figure/unnamed-chunk-16.png) 

```r

res_illit = lm(Income~scale(Illiteracy, scale=FALSE), data = state)
summary(res_illit)
```

```
## 
## Call:
## lm(formula = Income ~ scale(Illiteracy, scale = FALSE), data = state)
## 
## Residuals:
##    Min     1Q Median     3Q    Max 
## -948.9 -376.2  -49.8  347.0 2024.6 
## 
## Coefficients:
##                                  Estimate Std. Error t value Pr(>|t|)    
## (Intercept)                          4436         79   56.17   <2e-16 ***
## scale(Illiteracy, scale = FALSE)     -441        131   -3.37   0.0015 ** 
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 558 on 48 degrees of freedom
## Multiple R-squared:  0.191,	Adjusted R-squared:  0.174 
## F-statistic: 11.3 on 1 and 48 DF,  p-value: 0.00151
```


What is the effect of Murder Rate on Income?

```r
ggplot(state, 
       aes(x=scale(Murder, scale=FALSE), 
           y=Income)) +  # Adding color for mentill
  geom_point(shape=1) +  
  geom_smooth(method=lm) +
  theme_bw()
```

![plot of chunk unnamed-chunk-17](figure/unnamed-chunk-17.png) 

```r

res_murder = lm(Income~scale(Murder, scale=FALSE), data = state)
summary(res_illit)
```

```
## 
## Call:
## lm(formula = Income ~ scale(Illiteracy, scale = FALSE), data = state)
## 
## Residuals:
##    Min     1Q Median     3Q    Max 
## -948.9 -376.2  -49.8  347.0 2024.6 
## 
## Coefficients:
##                                  Estimate Std. Error t value Pr(>|t|)    
## (Intercept)                          4436         79   56.17   <2e-16 ***
## scale(Illiteracy, scale = FALSE)     -441        131   -3.37   0.0015 ** 
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 558 on 48 degrees of freedom
## Multiple R-squared:  0.191,	Adjusted R-squared:  0.174 
## F-statistic: 11.3 on 1 and 48 DF,  p-value: 0.00151
```


What about interactive (or additive) effects of illiteracy and murder rate on income?

```r
res_add = lm(Income ~ scale(Illiteracy, scale = FALSE) + scale(Murder, scale = FALSE), 
    data = state)

res_inter = lm(Income ~ scale(Illiteracy, scale = FALSE) * scale(Murder, scale = FALSE), 
    data = state)
summary(res_inter)
```

```
## 
## Call:
## lm(formula = Income ~ scale(Illiteracy, scale = FALSE) * scale(Murder, 
##     scale = FALSE), data = state)
## 
## Residuals:
##    Min     1Q Median     3Q    Max 
## -955.2 -326.0   10.7  300.0 1892.1 
## 
## Coefficients:
##                                                               Estimate
## (Intercept)                                                    4617.31
## scale(Illiteracy, scale = FALSE)                               -246.59
## scale(Murder, scale = FALSE)                                      9.82
## scale(Illiteracy, scale = FALSE):scale(Murder, scale = FALSE)  -117.10
##                                                               Std. Error
## (Intercept)                                                        96.34
## scale(Illiteracy, scale = FALSE)                                  200.26
## scale(Murder, scale = FALSE)                                       28.80
## scale(Illiteracy, scale = FALSE):scale(Murder, scale = FALSE)      40.13
##                                                               t value
## (Intercept)                                                     47.93
## scale(Illiteracy, scale = FALSE)                                -1.23
## scale(Murder, scale = FALSE)                                     0.34
## scale(Illiteracy, scale = FALSE):scale(Murder, scale = FALSE)   -2.92
##                                                               Pr(>|t|)    
## (Intercept)                                                     <2e-16 ***
## scale(Illiteracy, scale = FALSE)                                0.2244    
## scale(Murder, scale = FALSE)                                    0.7348    
## scale(Illiteracy, scale = FALSE):scale(Murder, scale = FALSE)   0.0054 ** 
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 520 on 46 degrees of freedom
## Multiple R-squared:  0.327,	Adjusted R-squared:  0.283 
## F-statistic: 7.46 on 3 and 46 DF,  p-value: 0.000359
```


Model comparison:

```r
anova(res_illit, res_add, res_inter)
```

```
## Analysis of Variance Table
## 
## Model 1: Income ~ scale(Illiteracy, scale = FALSE)
## Model 2: Income ~ scale(Illiteracy, scale = FALSE) + scale(Murder, scale = FALSE)
## Model 3: Income ~ scale(Illiteracy, scale = FALSE) * scale(Murder, scale = FALSE)
##   Res.Df      RSS Df Sum of Sq    F Pr(>F)   
## 1     48 14966741                            
## 2     47 14748893  1    217848 0.81 0.3742   
## 3     46 12445502  1   2303391 8.51 0.0054 **
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
```

Looks like our interactive model performs the best!


### Understanding our interaction

For a first step, it can be a good idea to visualize your data

```r
with(state, coplot(Income ~ scale(Murder, scale = FALSE) | scale(Illiteracy, 
    scale = FALSE)))
```

![plot of chunk unnamed-chunk-20](figure/unnamed-chunk-20.png) 

```r

# alternately, with(state,coplot(Income~ scale(Illiteracy, scale=FALSE) |
# scale(Murder, scale=FALSE)))
```



```r
# Slope at the mean of Illiteracy
summary(lm(Income ~ I(scale(Illiteracy)) * scale(Murder), data = state))
```

```
## 
## Call:
## lm(formula = Income ~ I(scale(Illiteracy)) * scale(Murder), data = state)
## 
## Residuals:
##    Min     1Q Median     3Q    Max 
## -955.2 -326.0   10.7  300.0 1892.1 
## 
## Coefficients:
##                                    Estimate Std. Error t value Pr(>|t|)
## (Intercept)                          4617.3       96.3   47.93   <2e-16
## I(scale(Illiteracy))                 -150.3      122.1   -1.23   0.2244
## scale(Murder)                          36.2      106.3    0.34   0.7348
## I(scale(Illiteracy)):scale(Murder)   -263.5       90.3   -2.92   0.0054
##                                       
## (Intercept)                        ***
## I(scale(Illiteracy))                  
## scale(Murder)                         
## I(scale(Illiteracy)):scale(Murder) ** 
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 520 on 46 degrees of freedom
## Multiple R-squared:  0.327,	Adjusted R-squared:  0.283 
## F-statistic: 7.46 on 3 and 46 DF,  p-value: 0.000359
```

```r

# Simple slope at scale(Illiteracy) + 1SD
summary(lm(Income ~ I(scale(Illiteracy) - 1) * scale(Murder), data = state))
```

```
## 
## Call:
## lm(formula = Income ~ I(scale(Illiteracy) - 1) * scale(Murder), 
##     data = state)
## 
## Residuals:
##    Min     1Q Median     3Q    Max 
## -955.2 -326.0   10.7  300.0 1892.1 
## 
## Coefficients:
##                                        Estimate Std. Error t value
## (Intercept)                              4467.0      179.0   24.96
## I(scale(Illiteracy) - 1)                 -150.3      122.1   -1.23
## scale(Murder)                            -227.2      151.7   -1.50
## I(scale(Illiteracy) - 1):scale(Murder)   -263.5       90.3   -2.92
##                                        Pr(>|t|)    
## (Intercept)                              <2e-16 ***
## I(scale(Illiteracy) - 1)                 0.2244    
## scale(Murder)                            0.1410    
## I(scale(Illiteracy) - 1):scale(Murder)   0.0054 ** 
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 520 on 46 degrees of freedom
## Multiple R-squared:  0.327,	Adjusted R-squared:  0.283 
## F-statistic: 7.46 on 3 and 46 DF,  p-value: 0.000359
```

```r

# Simple slope at scale(Illiteracy) - 1SD
summary(lm(Income ~ I(scale(Illiteracy) + 1) * scale(Murder), data = state))
```

```
## 
## Call:
## lm(formula = Income ~ I(scale(Illiteracy) + 1) * scale(Murder), 
##     data = state)
## 
## Residuals:
##    Min     1Q Median     3Q    Max 
## -955.2 -326.0   10.7  300.0 1892.1 
## 
## Coefficients:
##                                        Estimate Std. Error t value
## (Intercept)                              4767.6      127.8   37.31
## I(scale(Illiteracy) + 1)                 -150.3      122.1   -1.23
## scale(Murder)                             299.7      126.1    2.38
## I(scale(Illiteracy) + 1):scale(Murder)   -263.5       90.3   -2.92
##                                        Pr(>|t|)    
## (Intercept)                              <2e-16 ***
## I(scale(Illiteracy) + 1)                 0.2244    
## scale(Murder)                            0.0217 *  
## I(scale(Illiteracy) + 1):scale(Murder)   0.0054 ** 
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 520 on 46 degrees of freedom
## Multiple R-squared:  0.327,	Adjusted R-squared:  0.283 
## F-statistic: 7.46 on 3 and 46 DF,  p-value: 0.000359
```


1.  At the mean of Illiteracy: Income = 4617.31 + 36.23 * zMurder
2.  At +1 SD Illiteracy: Income = 4467 - 227.2 * zMurder
3.  At -1 SD Illiteracy: Income = 4767.6 + 299.7 * zMurder


```r
ggplot(state, 
       aes(x=scale(Murder), 
           y=Income)) +  # Adding color for mentill
  geom_point(shape=1) +  
  theme_bw() + 
  # effect of murder on income @mean illiteracy
  geom_abline(aes(intercept=4617.31, slope=36.23), colour='black') +
  # effect of murder on income @+1SD illiteracy
  geom_abline(aes(intercept=4467, slope=-227.2), colour='red') +
  # effect of murder on income @-1SD illiteracy
  geom_abline(aes(intercept=4767.6, slope=229.7), colour='green')+
  ggtitle('Interaction between Murder and Illiteracy on Income')
```

![plot of chunk unnamed-chunk-22](figure/unnamed-chunk-22.png) 


