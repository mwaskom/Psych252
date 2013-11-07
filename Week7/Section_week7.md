Section Week 7 - Partial correlations, Practice with contrasts, 2x3 ANOVA
========================================================

## Quiz 2 Feedback
----------------------

- Read questions carefully and give an attempted answer for every question

- Manage your time progressing through the quiz

- When testing something: 
1). state the name of the test, 
2). **Give formula or R command**, 
3). Show your work, rather than just writing a number, so that in case you are wrong, we can still give lots of partial credit!

- Calculate statistic and critical value or p value

- Reject the null (or not)

- Informal conclusion

- When writing up results: 
1). use a few numbers, *b = 3.21, t(23) = 2.42, p = 0.012*, 
2). Formal words: There was a significant quadratic effect of smiling on creepiness
3). Informal words: Those who smile more tend to be less creepy, but there is a point at which smiling too much causes an increase in creepiness.


Partial Correlations
----------------------

Remember that both the **Baron & Kenny method** and a test for **partial correlation** can test causal hypotheses.

Let's compare a test with partial correlation to mediation.  Let's quickly review our findings from the **coffee problem** from Homework 3.

**Causal Models**

**IV**: *Coffee* - 20 subjects in each group either had 0 cups, 2 cups, or 4 cups

**DV**: *Performance* - on a stats quiz with 10 problems, 5-89 points

**Possible Mediator 1**: *Number of problems attempted* (hyperactivity)

**Possible Mediator 2**: *Accuracy* - how likely they were to get a problem right if they tried (better success)


```r
d <- read.csv("http://www.stanford.edu/class/psych252/data/caffeine.csv")
str(d)
```

```
## 'data.frame':	62 obs. of  4 variables:
##  $ coffee : int  1 1 1 1 2 1 1 1 2 1 ...
##  $ perf   : int  53 9 31 38 40 40 9 37 62 23 ...
##  $ accur  : num  0.45 0.5 0.499 0.454 0.421 ...
##  $ numprob: int  7 6 6 7 8 6 6 8 7 7 ...
```

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


### Visualize your data!

```r
library(gpairs)
```

```
## Loading required package: barcode Loading required package: grid Loading
## required package: lattice Loading required package: vcd Loading required
## package: MASS Loading required package: colorspace
```

```r
gpairs(d, upper.pars = list(scatter = "lm", conditional = "barcode", mosaic = "mosaic"), 
    lower.pars = list(scatter = "stats", conditional = "boxplot", mosaic = "mosaic"), 
    stat.pars = list(fontsize = 14, signif = 0.05, verbose = FALSE, use.color = TRUE, 
        missing = "missing", just = "centre"))
```

```
## Warning: Cannot compute exact p-value with ties Warning: Cannot compute
## exact p-value with ties Warning: Cannot compute exact p-value with ties
## Warning: Cannot compute exact p-value with ties Warning: Cannot compute
## exact p-value with ties Warning: Cannot compute exact p-value with ties
## Warning: Cannot compute exact p-value with ties Warning: Cannot compute
## exact p-value with ties Warning: Cannot compute exact p-value with ties
## Warning: Cannot compute exact p-value with ties
```

![plot of chunk unnamed-chunk-1](figure/unnamed-chunk-1.png) 



### Mediation

Cups of Coffee $\longrightarrow$ Hyperactivity $\longrightarrow$ Performance
Here, "hyperactivity" is measured by the number of problems solved.

What's the model we don't need?:
*Mediator predicting our DV on its own. Just ignore this guy.*

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



```r
with(d, summary(lm(perf ~ cups)))  #c
```

```
## 
## Call:
## lm(formula = perf ~ cups)
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
with(d, summary(lm(numprob ~ cups)))  #a
```

```
## 
## Call:
## lm(formula = numprob ~ cups)
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
with(d, summary(lm(perf ~ cups + numprob)))  #b and c'
```

```
## 
## Call:
## lm(formula = perf ~ cups + numprob)
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



### Partial Correlation
Now let's compare this test of our causal model with a partial correlation test.  Partial correlations find the correlation between two variables after removing the effects of other variables.

x = **IV** *(cups of coffee)*

y = **DV** *(performance)*

z = **third variable** *(mediator)*


First, we'll need to find out what our correlations are.


```r
a = with(d, cor.test(cups, perf))
print(a)
```

```
## 
## 	Pearson's product-moment correlation
## 
## data:  cups and perf
## t = 2.711, df = 58, p-value = 0.0088
## alternative hypothesis: true correlation is not equal to 0
## 95 percent confidence interval:
##  0.08906 0.54307
## sample estimates:
##    cor 
## 0.3354
```

```r
b = with(d, cor.test(cups, numprob))
print(b)
```

```
## 
## 	Pearson's product-moment correlation
## 
## data:  cups and numprob
## t = 8.124, df = 58, p-value = 3.789e-11
## alternative hypothesis: true correlation is not equal to 0
## 95 percent confidence interval:
##  0.5838 0.8298
## sample estimates:
##    cor 
## 0.7296
```

```r
c = with(d, cor.test(numprob, perf))
print(c)
```

```
## 
## 	Pearson's product-moment correlation
## 
## data:  numprob and perf
## t = 3.511, df = 58, p-value = 0.0008722
## alternative hypothesis: true correlation is not equal to 0
## 95 percent confidence interval:
##  0.1843 0.6079
## sample estimates:
##    cor 
## 0.4186
```


What's the formula for a partial correlation?

$$\textrm{Partial Correlation }: r(xy.z) = \frac{{r_{xy} - r_{xz} * r_{yz}}}{\sqrt{(1-r_{xz}^2) * (1-r_{yz}^2)}}$$


```r
n <- 60
xy <- as.numeric(a$estimate)
xz <- as.numeric(b$estimate)
yz <- as.numeric(c$estimate)

r_xy_z <- (xy - (xz * yz))/(sqrt((1 - xz^2) * (1 - yz^2)))
print(r_xy_z)
```

```
## [1] 0.04826
```

```r
t2 <- r_xy_z * sqrt((n - 2)/(1 - r_xy_z^2))
print(t2)
```

```
## [1] 0.368
```

```r
ptr <- pt(t2, n - 2, lower.tail = FALSE)
print(ptr)
```

```
## [1] 0.3571
```


Now let's try wth accuracy, which we know isn't a mediator! 

Cups of Coffee $\leadsto$ Accuracy $\longrightarrow$ Performance

Quick review of what we found last time:


```r
with(d, summary(lm(perf ~ cups)))  #c
```

```
## 
## Call:
## lm(formula = perf ~ cups)
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
with(d, summary(lm(accur ~ cups)))  #a
```

```
## 
## Call:
## lm(formula = accur ~ cups)
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

```r
with(d, summary(lm(perf ~ cups + accur)))  #b and c'
```

```
## 
## Call:
## lm(formula = perf ~ cups + accur)
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
with(d, cor.test(cups, perf)) <- a
```

```
## Error: could not find function "with<-"
```

```r
print(a)
```

```
## 
## 	Pearson's product-moment correlation
## 
## data:  cups and perf
## t = 2.711, df = 58, p-value = 0.0088
## alternative hypothesis: true correlation is not equal to 0
## 95 percent confidence interval:
##  0.08906 0.54307
## sample estimates:
##    cor 
## 0.3354
```

```r
with(d, cor.test(cups, accur)) <- b
```

```
## Error: could not find function "with<-"
```

```r
print(b)
```

```
## 
## 	Pearson's product-moment correlation
## 
## data:  cups and numprob
## t = 8.124, df = 58, p-value = 3.789e-11
## alternative hypothesis: true correlation is not equal to 0
## 95 percent confidence interval:
##  0.5838 0.8298
## sample estimates:
##    cor 
## 0.7296
```

```r
with(d, cor.test(accur, perf)) <- c
```

```
## Error: could not find function "with<-"
```

```r
print(c)
```

```
## 
## 	Pearson's product-moment correlation
## 
## data:  numprob and perf
## t = 3.511, df = 58, p-value = 0.0008722
## alternative hypothesis: true correlation is not equal to 0
## 95 percent confidence interval:
##  0.1843 0.6079
## sample estimates:
##    cor 
## 0.4186
```



```r
n <- 60
xy <- as.numeric(a$estimate)
xz <- as.numeric(b$estimate)
yz <- as.numeric(c$estimate)

r_xy_z <- (xy - (xz * yz))/(sqrt((1 - xz^2) * (1 - yz^2)))
print(r_xy_z)
```

```
## [1] 0.04826
```

```r
t2 <- r_xy_z * sqrt((n - 2)/(1 - r_xy_z^2))
print(t2)
```

```
## [1] 0.368
```

```r
ptr <- pt(t2, n - 2, lower.tail = FALSE)
print(ptr)
```

```
## [1] 0.3571
```


### Partial Mediation w/`psych`: `partial.r()`

```r
library(psych)
`?`(partial.r)
```


For number of problems attempted:

```r
da = subset(d, select = c("cups", "perf", "numprob"))
partial.r(da, 1:2, 3)
```

```
## partial correlations 
##      cups perf
## cups 1.00 0.05
## perf 0.05 1.00
```


For accuracy:

```r
da1 = subset(d, select = c("cups", "perf", "accur"))
partial.r(da1, 1:2, 3)
```

```
## partial correlations 
##      cups perf
## cups 1.00 0.35
## perf 0.35 1.00
```


So far, we've considered causal models like this:
What if cups of coffee predicted both the number of problems attempted and performance, but performance and the number of problems weren't related? 

So instead of this model:

#### Cups of Coffee $\longrightarrow$ Hyperactivity $\longrightarrow$ Performance

We were interested in this model:

#### Cups of Coffee $\longrightarrow$ Hyperactivity

$\downarrow$

#### Performance


```r
n <- 60
xy <- 0.26
xz <- 0.32
yz <- 0.03

r_xy_z <- (xy - (xz * yz))/(sqrt((1 - xz^2) * (1 - yz^2)))
print(r_xy_z)
```

```
## [1] 0.2644
```

```r
t2 <- r_xy_z * sqrt((n - 2)/(1 - r_xy_z^2))
print(t2)
```

```
## [1] 2.088
```

```r
ptr <- pt(t2, n - 2, lower.tail = FALSE)
print(ptr)
```

```
## [1] 0.0206
```



Practice with Contrasts
----------------------

Let's practice interpreting contrasts!

Remember our handy function from last time to test for **orthogonality**? 

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


Orthogonal contrasts possible for 4 groups! *Remember that you can have k-1 contrasts, if k is the number of groups that you have*

There are three different sets of orthogonal contrasts that are useful for comparing 4 different groups. These are useful in different situations. Let's consider a series of experiments where we're interested in what predicts whether a grad student is willing to register early for a conference. What do each of these sets of contrasts test?

### When our IV is quantitative:

For instance, let's say that we're looking at level of trait anxiety on likelihood of reigstering early for a conference. 


```r
c1 <- cbind(c(-3, -1, 1, 3), c(1, -1, -1, 1), c(-1, 3, -3, 1))
c_orth_4(c1)
```

```
##           a b c
## Contrasts 0 0 0
## Sum 
##   0
```

```r
rownames(c1) <- c(1, 2, 3, 4)
print(c1)
```

```
##   [,1] [,2] [,3]
## 1   -3    1   -1
## 2   -1   -1    3
## 3    1   -1   -3
## 4    3    1    1
```


### When we have two levels of one factor, and two levels of another factor.

Let's say that Factor A is fee for late registration (low vs. high)
and Factor B is the number of days before the deadline a warning is issued (one week vs. 1 day)
on likelihood of early registration


```r
c2 <- cbind(c(1, 1, -1, -1), c(1, -1, 0, 0), c(0, 0, 1, -1))
c_orth_4(c2)
```

```
##           a b c
## Contrasts 0 0 0
## Sum 
##   0
```

```r
rownames(c2) <- c("reg1", "reg2", "days1", "days2")
print(c2)
```

```
##       [,1] [,2] [,3]
## reg1     1    1    0
## reg2     1   -1    0
## days1   -1    0    1
## days2   -1    0   -1
```


### When we're using a 2x2 factorial design:

Again, let's say that Factor A is gender (male vs. female)
and Factor B is framing of an issue (loss vs. gain)
on likelihood of early registration


```r
c3 <- cbind(c(-1, 1, -1, 1), c(-1, -1, 1, 1), c(1, -1, -1, 1))
c_orth_4(c3)
```

```
##           a b c
## Contrasts 0 0 0
## Sum 
##   0
```

```r
rownames(c3) <- c("men/loss", "women/loss", "men/gain", "women/gain")
print(c3)
```

```
##            [,1] [,2] [,3]
## men/loss     -1   -1    1
## women/loss    1   -1   -1
## men/gain     -1    1   -1
## women/gain    1    1    1
```


Visualizing our design matrix
----------------------

Load in some data

```r
d0 = read.csv("http://www.stanford.edu/class/psych252/data/lifesatis.csv")
str(d0)
```

```
## 'data.frame':	62 obs. of  6 variables:
##  $ id      : int  1 2 3 4 5 6 7 8 9 10 ...
##  $ age     : num  36 41.8 60 23.8 48 ...
##  $ kids    : int  0 1 0 0 1 0 5 0 0 0 ...
##  $ jobsatis: int  3 4 3 3 4 3 3 4 3 2 ...
##  $ marsatis: int  4 1 4 1 5 6 3 1 2 7 ...
##  $ lifsatis: int  4 1 3 2 4 4 4 4 2 4 ...
```

```r
d0$kids_cat[d0$kids < 1] = "None"
d0$kids_cat[d0$kids == 1] = "One"
d0$kids_cat[d0$kids > 1] = "Multiple"

d0$kids_cat = factor(d0$kids_cat)
str(d0)
```

```
## 'data.frame':	62 obs. of  7 variables:
##  $ id      : int  1 2 3 4 5 6 7 8 9 10 ...
##  $ age     : num  36 41.8 60 23.8 48 ...
##  $ kids    : int  0 1 0 0 1 0 5 0 0 0 ...
##  $ jobsatis: int  3 4 3 3 4 3 3 4 3 2 ...
##  $ marsatis: int  4 1 4 1 5 6 3 1 2 7 ...
##  $ lifsatis: int  4 1 3 2 4 4 4 4 2 4 ...
##  $ kids_cat: Factor w/ 3 levels "Multiple","None",..: 2 3 2 2 3 2 1 2 2 2 ...
```


### Visualize the data

```r
library(ggplot2)
```

```
## Attaching package: 'ggplot2'
## 
## The following object is masked from 'package:psych':
## 
## %+%
```

```r
ggplot(d0, aes(x = scale(marsatis), y = lifsatis, color = kids_cat)) + geom_point(shape = 1, 
    position = position_jitter(width = 0.1)) + geom_smooth(method = lm, se = TRUE) + 
    theme_bw()
```

![plot of chunk unnamed-chunk-12](figure/unnamed-chunk-121.png) 

```r

ggplot(d0, aes(kids_cat, lifsatis, color = kids_cat)) + geom_boxplot()
```

![plot of chunk unnamed-chunk-12](figure/unnamed-chunk-122.png) 


### View the design matrix

First let's set up some contrasts and see what the `lm()` output looks like:

```r
levels(d0$kids_cat)
```

```
## [1] "Multiple" "None"     "One"
```

```r
contrasts(d0$kids_cat) = cbind(c(1, -2, 1), c(1, 0, -1))

# orthogonal?
apply(contrasts(d0$kids_cat), 2, sum)
```

```
## [1] 0 0
```

```r

colnames(contrasts(d0$kids_cat)) = c("kids-vs-none", "multiple-vs-one")
contrasts(d0$kids_cat)
```

```
##          kids-vs-none multiple-vs-one
## Multiple            1               1
## None               -2               0
## One                 1              -1
```

```r

lm1 = lm(lifsatis ~ kids_cat, data = d0)
summary(lm1)
```

```
## 
## Call:
## lm(formula = lifsatis ~ kids_cat, data = d0)
## 
## Residuals:
##    Min     1Q Median     3Q    Max 
## -2.958 -0.958  0.042  1.042  3.267 
## 
## Coefficients:
##                         Estimate Std. Error t value Pr(>|t|)    
## (Intercept)                3.314      0.215   15.44   <2e-16 ***
## kids_catkids-vs-none       0.290      0.131    2.21    0.031 *  
## kids_catmultiple-vs-one    0.354      0.294    1.20    0.233    
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 1.44 on 59 degrees of freedom
## Multiple R-squared:  0.141,	Adjusted R-squared:  0.111 
## F-statistic: 4.83 on 2 and 59 DF,  p-value: 0.0114
```


Now, let's visualize our design matrix:

```r
m1 <- model.matrix(lm1)
head(m1)
```

```
##   (Intercept) kids_catkids-vs-none kids_catmultiple-vs-one
## 1           1                   -2                       0
## 2           1                    1                      -1
## 3           1                   -2                       0
## 4           1                   -2                       0
## 5           1                    1                      -1
## 6           1                   -2                       0
```

```r

library(gplots)  # to use the colorpanel() function
```

```
## KernSmooth 2.23 loaded Copyright M. P. Wand 1997-2009
## 
## Attaching package: 'gplots'
## 
## The following object is masked from 'package:stats':
## 
## lowess
```

```r

# plot design matrix for intercept + 2 contrasts
image(t(m1), axes = FALSE, frame.plot = TRUE, col = colorpanel(20, "white", 
    "grey10"), main = "Design Matrix", ylim = c(1, 0), ylab = "Row Number", 
    xlab = "Contrast")
```

![plot of chunk unnamed-chunk-14](figure/unnamed-chunk-141.png) 

```r

# add lifsatis data to matrix
m1 = cbind(m1, as.matrix(d0$lifsatis))
head(m1)
```

```
##   (Intercept) kids_catkids-vs-none kids_catmultiple-vs-one  
## 1           1                   -2                       0 4
## 2           1                    1                      -1 1
## 3           1                   -2                       0 3
## 4           1                   -2                       0 2
## 5           1                    1                      -1 4
## 6           1                   -2                       0 4
```

```r

# plot design matrix w/lifsatis data in last column
image(t(m1), axes = FALSE, frame.plot = TRUE, col = colorpanel(20, "white", 
    "grey10"), main = "Design Matrix", ylim = c(1, 0), ylab = "Row Number")
```

![plot of chunk unnamed-chunk-14](figure/unnamed-chunk-142.png) 



Calculate the significance of a contrast by hand!
---------------------------------------------

First let's get some stats:

```r
# some stats
k = 3  # number groups
means = aggregate(lifsatis ~ kids_cat, data = d0, function(x) mean(x))
means
```

```
##   kids_cat lifsatis
## 1 Multiple    3.958
## 2     None    2.733
## 3      One    3.250
```

```r
ns = aggregate(lifsatis ~ kids_cat, data = d0, function(x) length(x))
ns
```

```
##   kids_cat lifsatis
## 1 Multiple       24
## 2     None       30
## 3      One        8
```

```r
N = sum(ns[, 2])  # total participants
sems = aggregate(lifsatis ~ kids_cat, data = d0, function(x) (sd(x)/sqrt(length(x))))
sems
```

```
##   kids_cat lifsatis
## 1 Multiple   0.3155
## 2     None   0.2346
## 3      One   0.5901
```

```r
vars = aggregate(lifsatis ~ kids_cat, data = d0, function(x) (var(x)))
vars
```

```
##   kids_cat lifsatis
## 1 Multiple    2.389
## 2     None    1.651
## 3      One    2.786
```

```r
grand_mean = mean(d0$lifsatis)
grand_mean
```

```
## [1] 3.274
```

```r
mean_ofmeans = mean(means[, 2])
mean_ofmeans
```

```
## [1] 3.314
```

```r

# compare intercept to both means!
summary(lm1)
```

```
## 
## Call:
## lm(formula = lifsatis ~ kids_cat, data = d0)
## 
## Residuals:
##    Min     1Q Median     3Q    Max 
## -2.958 -0.958  0.042  1.042  3.267 
## 
## Coefficients:
##                         Estimate Std. Error t value Pr(>|t|)    
## (Intercept)                3.314      0.215   15.44   <2e-16 ***
## kids_catkids-vs-none       0.290      0.131    2.21    0.031 *  
## kids_catmultiple-vs-one    0.354      0.294    1.20    0.233    
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 1.44 on 59 degrees of freedom
## Multiple R-squared:  0.141,	Adjusted R-squared:  0.111 
## F-statistic: 4.83 on 2 and 59 DF,  p-value: 0.0114
```


Let's test our first contrast (whether having any kids improves life satisfaction).

```r
# pull out our contrast, and multiply each contrast by the group means
contrast1 = contrasts(d0$kids_cat)[, 1]
contrast1
```

```
## Multiple     None      One 
##        1       -2        1
```

```r
l1 = contrast1 * means[, 2]
l1
```

```
## Multiple     None      One 
##    3.958   -5.467    3.250
```

```r
l1 = sum(l1)
l1
```

```
## [1] 1.742
```

```r

# some more stats
T = sum(ns[, 2] * means[, 2])
T
```

```
## [1] 203
```

```r
C_val = (T^2)/N
C_val
```

```
## [1] 664.7
```

```r
SSj = (ns[, 2] - 1) * vars[, 2]
SSj
```

```
## [1] 54.96 47.87 19.50
```

```r
SSerror = sum(SSj)
SSerror
```

```
## [1] 122.3
```

```r
MSerror = SSerror/(N - k)
MSerror
```

```
## [1] 2.073
```

```r

# compare error to anova table from lm output
anova(lm1)
```

```
## Analysis of Variance Table
## 
## Response: lifsatis
##           Df Sum Sq Mean Sq F value Pr(>F)  
## kids_cat   2     20   10.01    4.83  0.011 *
## Residuals 59    122    2.07                 
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
```

```r

# Calculate t-stat
contrast1^2
```

```
## Multiple     None      One 
##        1        4        1
```

```r
(contrast1^2)/ns[, 2]
```

```
## Multiple     None      One 
##  0.04167  0.13333  0.12500
```

```r

se2 = MSerror * sum((contrast1^2)/ns[, 2])
se2
```

```
## [1] 0.622
```

```r

t_stat = l1/sqrt(se2)
t_stat
```

```
## [1] 2.208
```

```r
p_val = 2 * pt(t_stat, df = N - k, lower.tail = FALSE)
p_val
```

```
## [1] 0.03112
```

```r
cat("t (", N - k, ") = ", t_stat, ", p = ", p_val)
```

```
## t ( 59 ) =  2.208 , p =  0.03112
```

```r

# compare to lm output
summary(lm1)
```

```
## 
## Call:
## lm(formula = lifsatis ~ kids_cat, data = d0)
## 
## Residuals:
##    Min     1Q Median     3Q    Max 
## -2.958 -0.958  0.042  1.042  3.267 
## 
## Coefficients:
##                         Estimate Std. Error t value Pr(>|t|)    
## (Intercept)                3.314      0.215   15.44   <2e-16 ***
## kids_catkids-vs-none       0.290      0.131    2.21    0.031 *  
## kids_catmultiple-vs-one    0.354      0.294    1.20    0.233    
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 1.44 on 59 degrees of freedom
## Multiple R-squared:  0.141,	Adjusted R-squared:  0.111 
## F-statistic: 4.83 on 2 and 59 DF,  p-value: 0.0114
```


