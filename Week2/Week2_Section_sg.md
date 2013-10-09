Section Week 2 
========================================================

*1. Standard Deviation vs. Standard Error*
*2. Centering data and Standardizing data vs. "Normalizing" Data*
*3. T-tests and the null hypothesis*

## Standard Deviation vs. Standard Error

Standard Deviation


```r
## entering data -- let's say that we want to calculate the average
## temperature for palo alto.  so on 6 days we observe the temperature

d <- c(80, 76, 81, 72, 68, 76)

## calculating mean
m <- mean(d)
print(m)
```

```
## [1] 75.5
```

```r

## calculating number of observations
n <- length(d)
print(n)
```

```
## [1] 6
```

```r

## calculating standard deviation
sqrt(var(d))
```

```
## [1] 4.889
```

```r

# or

s <- sd(d)
print(s)
```

```
## [1] 4.889
```


Standard error


```r
se <- s/n^0.5
print(se)
```

```
## [1] 1.996
```

```r

# this also works:
se = s/sqrt(n)
print(se)
```

```
## [1] 1.996
```


Now we can use the standard error of the mean to calculate a confidence interval for the mean!


```r
## calculating 95% confidence interval
ci95 <- se * 1.96  ## why 1.96? Critical value for 95% CI
print(ci95)
```

```
## [1] 3.912
```

```r

# using R to get z scores, given p
alpha = 0.05
z_critical = qnorm(alpha/2, lower.tail = FALSE)
print(z_critical)
```

```
## [1] 1.96
```

```r

## adding and subtracting it from mean
lowerbound = m - ci95
upperbound = m + ci95
```


So the confidence interval for the mean is from 71.58 to 79.41, which means that the mean temperature in Palo Alto falls within this interval.

## Centering vs. Standardizing Data

So let's say we have a variable "i" and want to either center or standardize it.


```r
## we have a data set with 4 variables
dn <- c(3, 4, 15, 8)
i <- 3
i2 <- 4
i3 <- 15
i4 <- 8

## find mean and standard deviation for calculations
mn <- mean(dn)
print(mn)
```

```
## [1] 7.5
```

```r
sdn <- sd(dn)
print(sdn)
```

```
## [1] 5.447
```


Centering - subtracting mean from values


```r
ic = (i - mn)
print(ic)
```

```
## [1] -4.5
```

```r

i2c = (i2 - mn)
print(i2c)
```

```
## [1] -3.5
```

```r

i3c = (i3 - mn)
print(i3c)
```

```
## [1] 7.5
```

```r

i4c = (i4 - mn)
print(i4c)
```

```
## [1] 0.5
```

```r

## combine values

centered <- c(ic, i2c, i3c, i4c)
print(centered)
```

```
## [1] -4.5 -3.5  7.5  0.5
```

```r
plot(centered)
```

![plot of chunk unnamed-chunk-1](figure/unnamed-chunk-1.png) 


That took a while... can we do it using matrix/vector operations??


```r
icf = dn - mn

print(icf)
```

```
## [1] -4.5 -3.5  7.5  0.5
```

```r
plot(icf)
```

![plot of chunk unnamed-chunk-2](figure/unnamed-chunk-2.png) 


Note, there's a helpful function that R has called `scale` -- we can use this to automatically center our data, like this:

```r
centered_data = scale(dn, scale = FALSE)

print(centered_data)
```

```
##      [,1]
## [1,] -4.5
## [2,] -3.5
## [3,]  7.5
## [4,]  0.5
## attr(,"scaled:center")
## [1] 7.5
```

```r
plot(centered_data)
```

![plot of chunk unnamed-chunk-3](figure/unnamed-chunk-3.png) 

n.b., if you just want to center the data, set **scale = FALSE**!



Now what is our mean and standard deviation?


```r
mean(icf)
```

```
## [1] 0
```

```r
sd(icf)
```

```
## [1] 5.447
```


Standardization - subtracting mean, dividing by standard deviation


```r
is = (i - mn)/sdn
print(is)
```

```
## [1] -0.8262
```

```r

standard <- (dn - mn)/sdn

print(standard)
```

```
## [1] -0.8262 -0.6426  1.3770  0.0918
```

```r
plot(standard)
```

![plot of chunk unnamed-chunk-5](figure/unnamed-chunk-5.png) 


Now let's take a look at our mean and sd...


```r
mean(standard)
```

```
## [1] -1.735e-17
```

```r
sd(standard)
```

```
## [1] 1
```


You can do this with the scale function too!

```r
standardized_data = scale(dn, scale = TRUE)

print(standardized_data)
```

```
##         [,1]
## [1,] -0.8262
## [2,] -0.6426
## [3,]  1.3770
## [4,]  0.0918
## attr(,"scaled:center")
## [1] 7.5
## attr(,"scaled:scale")
## [1] 5.447
```

```r
plot(standardized_data)
```

![plot of chunk unnamed-chunk-7](figure/unnamed-chunk-7.png) 




How do you do this on a dataset in R?


```r
# setwd
d2 = read.csv("dataset_scale.csv")
```


We're looking at a dataset of height and salary.  Let's check it out...


```r
summary(d2)
```

```
##      height         salary      
##  Min.   :4.20   Min.   : 22000  
##  1st Qu.:4.75   1st Qu.: 52250  
##  Median :5.50   Median : 63000  
##  Mean   :5.36   Mean   : 71300  
##  3rd Qu.:5.85   3rd Qu.: 80750  
##  Max.   :6.60   Max.   :217000
```

```r
head(d2)
```

```
##   height salary
## 1    4.2  53000
## 2    4.3  66000
## 3    4.6  35000
## 4    4.6  55000
## 5    4.6  67000
## 6    4.8  80000
```

```r
tail(d2)
```

```
##    height salary
## 15    5.8  83000
## 16    6.0  77000
## 17    6.1 100000
## 18    6.1  83000
## 19    6.4  75000
## 20    6.6 217000
```

```r
str(d2$height)
```

```
##  num [1:20] 4.2 4.3 4.6 4.6 4.6 4.8 4.9 5.2 5.3 5.5 ...
```


We're working with height here, so it doesn't make sense to talk about expected salary when height is set to 0 - the mean is more interpretable.  So we center!

Center the data!


```r
# before centering
with(d2, plot(height, salary))
```

![plot of chunk unnamed-chunk-8](figure/unnamed-chunk-81.png) 

```r


d2$heightc = with(d2, scale(height, center = TRUE, scale = FALSE))
head(d2$heightc)
```

```
##       [,1]
## [1,] -1.16
## [2,] -1.06
## [3,] -0.76
## [4,] -0.76
## [5,] -0.76
## [6,] -0.56
```

```r
with(d2, plot(heightc, salary))
abline(v = 0, col = "red", lty = 2)
```

![plot of chunk unnamed-chunk-8](figure/unnamed-chunk-82.png) 


Create standardized scores!


```r
d2$heights = with(d2, scale(height, center = TRUE, scale = TRUE))
head(d2$heights)
```

```
##         [,1]
## [1,] -1.6609
## [2,] -1.5177
## [3,] -1.0882
## [4,] -1.0882
## [5,] -1.0882
## [6,] -0.8018
```

```r
with(d2, plot(heights, salary))
abline(v = 0, col = "red", lty = 2)
```

![plot of chunk unnamed-chunk-9](figure/unnamed-chunk-9.png) 


Now let's reexamine our data set...


```r
summary(d2)
```

```
##      height         salary         heightc.V1       heights.V1    
##  Min.   :4.20   Min.   : 22000   Min.   :-1.16   Min.   :-1.6609  
##  1st Qu.:4.75   1st Qu.: 52250   1st Qu.:-0.61   1st Qu.:-0.8734  
##  Median :5.50   Median : 63000   Median : 0.14   Median : 0.2005  
##  Mean   :5.36   Mean   : 71300   Mean   : 0.00   Mean   : 0.0000  
##  3rd Qu.:5.85   3rd Qu.: 80750   3rd Qu.: 0.49   3rd Qu.: 0.7016  
##  Max.   :6.60   Max.   :217000   Max.   : 1.24   Max.   : 1.7754
```

```r
sd(d2$heightc)
```

```
## [1] 0.6984
```

```r
sd(d2$heights)
```

```
## [1] 1
```


Note that the means are 0, and the differences in standard deviation.

Does this affect our output?


```r
# non normalized
rs1 = lm(d2$salary ~ d2$height)
summary(rs1)
```

```
## 
## Call:
## lm(formula = d2$salary ~ d2$height)
## 
## Residuals:
##    Min     1Q Median     3Q    Max 
## -53746 -17334 -11510  18864 106319 
## 
## Coefficients:
##             Estimate Std. Error t value Pr(>|t|)  
## (Intercept)   -98927      60311   -1.64    0.118  
## d2$height      31759      11162    2.85    0.011 *
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 34000 on 18 degrees of freedom
## Multiple R-squared:  0.31,	Adjusted R-squared:  0.272 
## F-statistic: 8.09 on 1 and 18 DF,  p-value: 0.0107
```

```r
plot(d2$height, d2$salary)
lines(abline(rs1, col = "red"))
```

![plot of chunk tests with normalized variables](figure/tests_with_normalized_variables1.png) 

```r

# centered
rs2 = lm(d2$salary ~ d2$heightc)
summary(rs2)
```

```
## 
## Call:
## lm(formula = d2$salary ~ d2$heightc)
## 
## Residuals:
##    Min     1Q Median     3Q    Max 
## -53746 -17334 -11510  18864 106319 
## 
## Coefficients:
##             Estimate Std. Error t value Pr(>|t|)    
## (Intercept)    71300       7599    9.38  2.4e-08 ***
## d2$heightc     31759      11162    2.85    0.011 *  
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 34000 on 18 degrees of freedom
## Multiple R-squared:  0.31,	Adjusted R-squared:  0.272 
## F-statistic: 8.09 on 1 and 18 DF,  p-value: 0.0107
```

```r

plot(d2$heightc, d2$salary)
lines(abline(rs2, col = "red"))
```

![plot of chunk tests with normalized variables](figure/tests_with_normalized_variables2.png) 

```r

# standardized
rs3 = lm(d2$salary ~ d2$heights)
summary(rs3)
```

```
## 
## Call:
## lm(formula = d2$salary ~ d2$heights)
## 
## Residuals:
##    Min     1Q Median     3Q    Max 
## -53746 -17334 -11510  18864 106319 
## 
## Coefficients:
##             Estimate Std. Error t value Pr(>|t|)    
## (Intercept)    71300       7599    9.38  2.4e-08 ***
## d2$heights     22181       7796    2.85    0.011 *  
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 34000 on 18 degrees of freedom
## Multiple R-squared:  0.31,	Adjusted R-squared:  0.272 
## F-statistic: 8.09 on 1 and 18 DF,  p-value: 0.0107
```

```r
plot(d2$heights, d2$salary)
lines(abline(rs3, col = "red"))
```

![plot of chunk tests with normalized variables](figure/tests_with_normalized_variables3.png) 


Note the change in estimates for the last part, but that significance never changes.
Note also the intercept.

### Differences between normalizing data and normal distributions

Standardizing data doesn't fix problems of skewness.  Let's take a look at a skewed distribution


```r
x0 = c(1:3, 5, 7, 7, 7, 8, 8, 8, 8, 9, 9, 9)
plot(x0)
```

![plot of chunk unnamed-chunk-11](figure/unnamed-chunk-111.png) 

```r
hist(x0)
```

![plot of chunk unnamed-chunk-11](figure/unnamed-chunk-112.png) 

```r

msk = mean(x0)
print(msk)
```

```
## [1] 6.5
```

```r

sdsk = sd(x0)
print(sdsk)
```

```
## [1] 2.682
```

```r

## load psych library, test for skewness
install.packages("psych")
```

```
## Installing package into
## '/Applications/RStudio.app/Contents/Resources/R/library' (as 'lib' is
## unspecified)
```

```
## Error: trying to use CRAN without setting a mirror
```

```r
library(psych)
skew(x0)
```

```
## [1] -0.8999
```


Now let's standardize...


```r

skewst = (x0 - msk)/sdsk

print(skewst)
```

```
##  [1] -2.0508 -1.6779 -1.3051 -0.5593  0.1864  0.1864  0.1864  0.5593
##  [9]  0.5593  0.5593  0.5593  0.9322  0.9322  0.9322
```

```r
hist(skewst)
```

![plot of chunk standardizing skewed distributions](figure/standardizing_skewed_distributions.png) 

```r

## now we can see that the mean and SD are at 0 and 1
mean(skewst)
```

```
## [1] 5.878e-18
```

```r
sd(skewst)
```

```
## [1] 1
```

```r

## BUT the plot looks exactly the same -- the data is still skewed!
skew(skewst)
```

```
## [1] -0.8999
```


## T-tests and the Null Hypothesis

Let's generate a distribution that represents the null.


```r

## generating random data

group = rnorm(100, mean = 0, sd = 1)
```


Let's plot this distribution.


```r
hist(group)
```

![plot of chunk plot null](figure/plot_null.png) 


Let's do a t.test -- is this different from 0?

```r
t.test(group)
```

```
## 
## 	One Sample t-test
## 
## data:  group
## t = 0.0917, df = 99, p-value = 0.9271
## alternative hypothesis: true mean is not equal to 0
## 95 percent confidence interval:
##  -0.2084  0.2285
## sample estimates:
## mean of x 
##    0.0101
```


Taking samples from a distribution

```r
samp1 = sample(group, size = 10, replace = F)
t.stat = t.test(samp1)$statistic
print(t.stat)
```

```
##      t 
## -1.467
```


If we took 1000 samples from this distribution:


```r
scores = group
R = 1000
t.values = numeric(R)

for (i in 1:R) {
    groups = sample(scores, size = 100, replace = T)
    t.values[i] = t.test(groups)$statistic
}
```


Plotting t values!


```r
hist(t.values, breaks = 20)
```

![plot of chunk plot t-values](figure/plot_t-values.png) 


Some t-values that are outside of the range!

## Power


```r
m <- 5
sd <- 2
n <- 20
alpha = 0.05

sterr = sd/sqrt(n)

tstat = qt(alpha/2, df = n - 1, lower.tail = FALSE)
print(tstat)
```

```
## [1] 2.093
```

```r

merror = tstat * sterr
print(merror)
```

```
## [1] 0.936
```

```r

left = m - merror
right = m + merror
print(left)
```

```
## [1] 4.064
```

```r
print(right)
```

```
## [1] 5.936
```



```r
t = m + 1.5
print(t)
```

```
## [1] 6.5
```

```r
tleft = (left - t)/(s/sqrt(n))
tright = (right - t)/(s/sqrt(n))
print(tleft)
```

```
## [1] -2.228
```

```r
print(tright)
```

```
## [1] -0.5159
```

```r
p = pt(tright, df = n - 1) - pt(tleft, df = n - 1)
print(p)
```

```
## [1] 0.2869
```


Doing this same calculation in one line:


```r
power.t.test(n = n, delta = 1.5, sd = sd, sig.level = 0.05, type = "one.sample", 
    alternative = "two.sided")
```

```
## 
##      One-sample t test power calculation 
## 
##               n = 20
##           delta = 1.5
##              sd = 2
##       sig.level = 0.05
##           power = 0.8888
##     alternative = two.sided
```


What else can this function do?


```r
power.t.test(delta = 1.5, sd = sd, sig.level = 0.05, power = 0.8, type = "one.sample", 
    alternative = "two.sided")  #80% power
```

```
## 
##      One-sample t test power calculation 
## 
##               n = 15.98
##           delta = 1.5
##              sd = 2
##       sig.level = 0.05
##           power = 0.8
##     alternative = two.sided
```

```r

power.t.test(delta = 1.5, sd = sd, sig.level = 0.05, power = 0.9, type = "one.sample", 
    alternative = "two.sided")  #90% power
```

```
## 
##      One-sample t test power calculation 
## 
##               n = 20.7
##           delta = 1.5
##              sd = 2
##       sig.level = 0.05
##           power = 0.9
##     alternative = two.sided
```

