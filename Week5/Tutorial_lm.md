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

```r
library(ggplot2)

ggplot(d0, aes(x = mentill, y = futhrt)) + geom_boxplot() + stat_summary(fun.y = mean, 
    geom = "point", shape = 5, size = 4)
```

![plot of chunk unnamed-chunk-3](figure/unnamed-chunk-31.png) 

```r

ggplot(d0, aes(x = futhrt, y = guilt, color = mentill)) + geom_point(shape = 1, 
    position = position_jitter(width = 0.25, height = 0.25)) + geom_smooth(method = lm, 
    fullrange = TRUE)
```

![plot of chunk unnamed-chunk-3](figure/unnamed-chunk-32.png) 


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
t.test(futhrt ~ mentill, data = d0, paired = FALSE, var.equal = TRUE)
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


More complicated questions (testing the relationship between multiple variables)
-------------------------------------------------


# interactions/slopes

# quadratic terms and poly, modeling the data

# linear components & quadratic componenets, plus how to interpret the interaction

# model comparison
