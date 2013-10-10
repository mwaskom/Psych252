Section 10.9.2013
========================================================

## Online applets
### Regression and Residuals
### Power

## Chi Square

Data: 'Type' and 'Complain' - what are we looking at?

Most of the variables are the same as in the Class Project on memory bias: Type = 1, 2, 3 refers to ‘free’, ‘biased’ and ‘varied’ recall, respectively; Complain = 1, if you seriously considered complaining when you missed your plane/train, and Complain = 0, otherwise. 


```r
d0 <- read.csv("http://www.stanford.edu/class/psych252/data/hw2data.csv")

str(d0)
```

```
## 'data.frame':	63 obs. of  6 variables:
##  $ Type       : int  2 3 1 3 1 1 2 3 1 2 ...
##  $ Pasthapp   : int  2 10 2 5 7 0 2 10 8 4 ...
##  $ Responsible: int  10 5 18 15 17 20 20 14 14 6 ...
##  $ Futurehapp : int  5 5 3 0 7 5 5 11 8 5 ...
##  $ FTP        : int  12 18 9 15 17 15 19 7 14 15 ...
##  $ complain   : int  1 1 0 1 1 0 0 0 1 1 ...
```


Why change to a factor?  What tests would we use if we weren't looking at "Type" and "Complain", but other variables? Refer to ppt


```r

d0$Typefac <- factor(d0$Type, labels = c("free", "biased", "varied"))

str(d0$Typefac)
```

```
##  Factor w/ 3 levels "free","biased",..: 2 3 1 3 1 1 2 3 1 2 ...
```

```r

d0$complainf <- factor(d0$complain, labels = c("yes", "no"))

str(d0$complainf)
```

```
##  Factor w/ 2 levels "yes","no": 2 2 1 2 2 1 1 1 2 2 ...
```

```r

str(d0)
```

```
## 'data.frame':	63 obs. of  8 variables:
##  $ Type       : int  2 3 1 3 1 1 2 3 1 2 ...
##  $ Pasthapp   : int  2 10 2 5 7 0 2 10 8 4 ...
##  $ Responsible: int  10 5 18 15 17 20 20 14 14 6 ...
##  $ Futurehapp : int  5 5 3 0 7 5 5 11 8 5 ...
##  $ FTP        : int  12 18 9 15 17 15 19 7 14 15 ...
##  $ complain   : int  1 1 0 1 1 0 0 0 1 1 ...
##  $ Typefac    : Factor w/ 3 levels "free","biased",..: 2 3 1 3 1 1 2 3 1 2 ...
##  $ complainf  : Factor w/ 2 levels "yes","no": 2 2 1 2 2 1 1 1 2 2 ...
```


Double check, and find out this coded incorrectly!


```r

d0$complainfac <- factor(d0$complain, labels = c("no", "yes"))

str(d0$complainfac)
```

```
##  Factor w/ 2 levels "no","yes": 2 2 1 2 2 1 1 1 2 2 ...
```

```r

str(d0)
```

```
## 'data.frame':	63 obs. of  9 variables:
##  $ Type       : int  2 3 1 3 1 1 2 3 1 2 ...
##  $ Pasthapp   : int  2 10 2 5 7 0 2 10 8 4 ...
##  $ Responsible: int  10 5 18 15 17 20 20 14 14 6 ...
##  $ Futurehapp : int  5 5 3 0 7 5 5 11 8 5 ...
##  $ FTP        : int  12 18 9 15 17 15 19 7 14 15 ...
##  $ complain   : int  1 1 0 1 1 0 0 0 1 1 ...
##  $ Typefac    : Factor w/ 3 levels "free","biased",..: 2 3 1 3 1 1 2 3 1 2 ...
##  $ complainf  : Factor w/ 2 levels "yes","no": 2 2 1 2 2 1 1 1 2 2 ...
##  $ complainfac: Factor w/ 2 levels "no","yes": 2 2 1 2 2 1 1 1 2 2 ...
```


Creating table of the data


```r

t0 <- table(d0$Typefac, d0$complainfac)
print(t0)
```

```
##         
##          no yes
##   free   12  10
##   biased 13  10
##   varied  8  10
```


Compare to table if had coded incorrectly


```r

table(d0$Typefac, d0$complainf)
```

```
##         
##          yes no
##   free    12 10
##   biased  13 10
##   varied   8 10
```


Interlude: what does it mean to do a chi square test?
What are some examples of relationships we would examine using a chi square test?
What is H0? H1?

Chi square by hand!

Calculating chi sq stat: ((10-10.47)^2)/10.47+((10-10.95)^2)/10.95+((10-8.57)^2)/8.57+((12-11.52)^2)/11.52+((13-12.04)^2)/12.04+((8-9.42)^2)/9.42

Table for critical values: http://sites.stat.psu.edu/~mga/401/tables/Chi-square-table.pdf


```r

rs0 <- chisq.test(t0)  ## chisq.test(table(d0$Typefac, d0$complainfac))
print(rs0)
```

```
## 
## 	Pearson's Chi-squared test
## 
## data:  t0
## X-squared = 0.654, df = 2, p-value = 0.7211
```


How do we interpret these results?  
What does it mean if we fail to reject the null?

APA writeup: 

A chi-square test of independence was performed to examine the relation between type of recall and whether or not participants reported considering complaining at the time. The relation between these variables was not significant, $latex {\chi^2_2}$ (2, N = 63) = 0.654, p = .72. Participants in one of the three memory groups were no more likely than the other groups to report having considered complaining for missing their train or plane.

The number of participants who considered complaining did not differ by recall type, c2(2, N = 63) = 0.654, p = .72.

## Data examination and transformation

We've already loaded our data so we're good to go! Let's take a look at the data.


```r

aggregate(Futurehapp ~ Typefac, d0, function(x) (c(mean(x), sd(x))))
```

```
##   Typefac Futurehapp.1 Futurehapp.2
## 1    free        5.045        3.373
## 2  biased        4.304        1.893
## 3  varied        3.222        3.439
```

```r

with(d0, boxplot(Futurehapp ~ Typefac))
```

![plot of chunk data examination](figure/data_examination.png) 


Should we transform the data?

Testing homogeneity of variance


```r

with(d0, bartlett.test(Futurehapp ~ Typefac, na.action = na.omit))
```

```
## 
## 	Bartlett test of homogeneity of variances
## 
## data:  Futurehapp by Typefac
## Bartlett's K-squared = 8.107, df = 2, p-value = 0.01736
```

```r

with(d0, hist(Futurehapp))
```

![plot of chunk bartlett test](figure/bartlett_test.png) 


When data is not normal the test might just be telling us so!

Log transform the data to normalize and redo the boxplot

What transformation should I use? Refer to ppt for examples


```r

d0$lgfhap = with(d0, log(Futurehapp + 0.5))

with(d0, boxplot(lgfhap ~ Typefac))
```

![plot of chunk log transform](figure/log_transform1.png) 

```r

with(d0, hist(lgfhap))
```

![plot of chunk log transform](figure/log_transform2.png) 


Rerun bartlett test with log transformed data


```r

with(d0, bartlett.test(lgfhap ~ Typefac, na.action = na.omit))
```

```
## 
## 	Bartlett test of homogeneity of variances
## 
## data:  lgfhap by Typefac
## Bartlett's K-squared = 16.5, df = 2, p-value = 0.0002617
```


What does this mean?  Variances are different no matter how we look at them!

Run anova with transformed data


```r

oneway.test(lgfhap ~ Typefac, data = d0, na.action = na.omit, var.equal = T)
```

```
## 
## 	One-way analysis of means
## 
## data:  lgfhap and Typefac
## F = 5.563, num df = 2, denom df = 60, p-value = 0.006078
```

```r

oneway.test(lgfhap ~ Typefac, data = d0, na.action = na.omit, var.equal = F)
```

```
## 
## 	One-way analysis of means (not assuming equal variances)
## 
## data:  lgfhap and Typefac
## F = 3.117, num df = 2.00, denom df = 33.76, p-value = 0.05725
```


Note how a marginal difference appears to be highly significant

Let's see how ignoring the transformation might have affected our results


```r

oneway.test(Futurehapp ~ Typefac, data = d0, na.action = na.omit, var.equal = TRUE)
```

```
## 
## 	One-way analysis of means
## 
## data:  Futurehapp and Typefac
## F = 1.908, num df = 2, denom df = 60, p-value = 0.1573
```

```r

oneway.test(Futurehapp ~ Typefac, data = d0, na.action = na.omit, var.equal = F)
```

```
## 
## 	One-way analysis of means (not assuming equal variances)
## 
## data:  Futurehapp and Typefac
## F = 1.392, num df = 2.00, denom df = 33.99, p-value = 0.2623
```


With the variable coded as it was the test is never significant. Perhaps because the distributions are not normal. 


## Multiple Regression


```r
res1a = lm(Futurehapp ~ Pasthapp, data = d0)
summary(res1a)
```

```
## 
## Call:
## lm(formula = Futurehapp ~ Pasthapp, data = d0)
## 
## Residuals:
##    Min     1Q Median     3Q    Max 
## -4.588 -2.044 -0.042  1.505 10.685 
## 
## Coefficients:
##             Estimate Std. Error t value Pr(>|t|)    
## (Intercept)    2.949      0.607    4.86  8.7e-06 ***
## Pasthapp       0.273      0.103    2.66   0.0099 ** 
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 2.85 on 61 degrees of freedom
## Multiple R-squared:  0.104,	Adjusted R-squared:  0.0895 
## F-statistic:  7.1 on 1 and 61 DF,  p-value: 0.00987
```

```r

res1b = lm(Futurehapp ~ Responsible, data = d0)
summary(res1b)
```

```
## 
## Call:
## lm(formula = Futurehapp ~ Responsible, data = d0)
## 
## Residuals:
##    Min     1Q Median     3Q    Max 
## -4.877 -2.221  0.123  1.372 10.331 
## 
## Coefficients:
##             Estimate Std. Error t value Pr(>|t|)    
## (Intercept)    3.107      0.738    4.21  8.6e-05 ***
## Responsible    0.104      0.058    1.79    0.078 .  
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 2.93 on 61 degrees of freedom
## Multiple R-squared:  0.0501,	Adjusted R-squared:  0.0345 
## F-statistic: 3.22 on 1 and 61 DF,  p-value: 0.0778
```

```r

res2 = lm(Futurehapp ~ Pasthapp + Responsible, data = d0)
summary(res2)
```

```
## 
## Call:
## lm(formula = Futurehapp ~ Pasthapp + Responsible, data = d0)
## 
## Residuals:
##    Min     1Q Median     3Q    Max 
## -4.830 -1.941 -0.045  1.404 10.170 
## 
## Coefficients:
##             Estimate Std. Error t value Pr(>|t|)   
## (Intercept)    1.389      0.892    1.56   0.1246   
## Pasthapp       0.305      0.100    3.05   0.0034 **
## Responsible    0.128      0.055    2.32   0.0238 * 
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 2.75 on 60 degrees of freedom
## Multiple R-squared:  0.178,	Adjusted R-squared:  0.151 
## F-statistic: 6.49 on 2 and 60 DF,  p-value: 0.0028
```

```r

anova(res1b, res2)
```

```
## Analysis of Variance Table
## 
## Model 1: Futurehapp ~ Responsible
## Model 2: Futurehapp ~ Pasthapp + Responsible
##   Res.Df RSS Df Sum of Sq    F Pr(>F)   
## 1     61 524                            
## 2     60 454  1      70.6 9.33 0.0034 **
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
```



```r
d0_corr = data.frame(cbind(d0$Futurehapp, d0$Responsible, d0$Pasthapp))
d0_corr_matrix = cbind(d0$Futurehapp, d0$Responsible, d0$Pasthapp)

colnames(d0_corr) = c("FutureHapp", "Responsible", "PastHapp")
head(d0_corr)
```

```
##   FutureHapp Responsible PastHapp
## 1          5          10        2
## 2          5           5       10
## 3          3          18        2
## 4          0          15        5
## 5          7          17        7
## 6          5          20        0
```

```r

z <- cor(d0_corr)
print(z)
```

```
##             FutureHapp Responsible PastHapp
## FutureHapp      1.0000      0.2239   0.3228
## Responsible     0.2239      1.0000  -0.1396
## PastHapp        0.3228     -0.1396   1.0000
```

```r

require(lattice)
```

```
## Loading required package: lattice
```

```r
levelplot(z, panel = panel.levelplot.raster, par.settings = list(regions = list(col = heat.colors(100))))
```

![plot of chunk correlations between multiple variables](figure/correlations_between_multiple_variables.png) 


## Dummy/Contrast/Effect Coding

```r
d0$Type <- factor(d0$Type, labels = c("free", "biased", "varied"))

with(d0, boxplot(Futurehapp ~ Type))
```

![plot of chunk dummy coding](figure/dummy_coding.png) 

```r

rs1 = lm(Futurehapp ~ Type, data = d0)
summary(rs1)
```

```
## 
## Call:
## lm(formula = Futurehapp ~ Type, data = d0)
## 
## Residuals:
##    Min     1Q Median     3Q    Max 
## -4.045 -2.175 -0.045  1.778  9.955 
## 
## Coefficients:
##             Estimate Std. Error t value Pr(>|t|)    
## (Intercept)    5.045      0.627    8.05  4.1e-11 ***
## Typebiased    -0.741      0.877   -0.85    0.401    
## Typevaried    -1.823      0.935   -1.95    0.056 .  
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 2.94 on 60 degrees of freedom
## Multiple R-squared:  0.0598,	Adjusted R-squared:  0.0285 
## F-statistic: 1.91 on 2 and 60 DF,  p-value: 0.157
```

```r

contrasts(d0$Type)
```

```
##        biased varied
## free        0      0
## biased      1      0
## varied      0      1
```

```r

# change contasts
contrasts(d0$Type) <- cbind(c(1, 0, 0), c(0, 0, 1))
contrasts(d0$Type)
```

```
##        [,1] [,2]
## free      1    0
## biased    0    0
## varied    0    1
```

```r

rs2 = lm(Futurehapp ~ Type, data = d0)
summary(rs2)
```

```
## 
## Call:
## lm(formula = Futurehapp ~ Type, data = d0)
## 
## Residuals:
##    Min     1Q Median     3Q    Max 
## -4.045 -2.175 -0.045  1.778  9.955 
## 
## Coefficients:
##             Estimate Std. Error t value Pr(>|t|)    
## (Intercept)    4.304      0.613    7.02  2.3e-09 ***
## Type1          0.741      0.877    0.85     0.40    
## Type2         -1.082      0.925   -1.17     0.25    
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 2.94 on 60 degrees of freedom
## Multiple R-squared:  0.0598,	Adjusted R-squared:  0.0285 
## F-statistic: 1.91 on 2 and 60 DF,  p-value: 0.157
```

```r

# contrast coding
contrasts(d0$Type) <- cbind(c(1, 1, -2), c(1, -1, 0))
contrasts(d0$Type)
```

```
##        [,1] [,2]
## free      1    1
## biased    1   -1
## varied   -2    0
```

```r

rs2 = lm(Futurehapp ~ Type, data = d0)
summary(rs2)
```

```
## 
## Call:
## lm(formula = Futurehapp ~ Type, data = d0)
## 
## Residuals:
##    Min     1Q Median     3Q    Max 
## -4.045 -2.175 -0.045  1.778  9.955 
## 
## Coefficients:
##             Estimate Std. Error t value Pr(>|t|)    
## (Intercept)    4.191      0.373   11.25   <2e-16 ***
## Type1          0.484      0.273    1.77    0.082 .  
## Type2          0.371      0.439    0.85    0.401    
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 2.94 on 60 degrees of freedom
## Multiple R-squared:  0.0598,	Adjusted R-squared:  0.0285 
## F-statistic: 1.91 on 2 and 60 DF,  p-value: 0.157
```

```r

# effect coding
contrasts(d0$Type) <- cbind(c(1, 0, -1), c(0, 1, -1))
contrasts(d0$Type)
```

```
##        [,1] [,2]
## free      1    0
## biased    0    1
## varied   -1   -1
```

```r

rs2 = lm(Futurehapp ~ Type, data = d0)
summary(rs2)
```

```
## 
## Call:
## lm(formula = Futurehapp ~ Type, data = d0)
## 
## Residuals:
##    Min     1Q Median     3Q    Max 
## -4.045 -2.175 -0.045  1.778  9.955 
## 
## Coefficients:
##             Estimate Std. Error t value Pr(>|t|)    
## (Intercept)    4.191      0.373   11.25   <2e-16 ***
## Type1          0.855      0.520    1.65     0.11    
## Type2          0.114      0.514    0.22     0.83    
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 2.94 on 60 degrees of freedom
## Multiple R-squared:  0.0598,	Adjusted R-squared:  0.0285 
## F-statistic: 1.91 on 2 and 60 DF,  p-value: 0.157
```


## Centering continuous variables & lm() output

```r
res1a = lm(Futurehapp ~ Pasthapp, data = d0)
summary(res1a)
```

```
## 
## Call:
## lm(formula = Futurehapp ~ Pasthapp, data = d0)
## 
## Residuals:
##    Min     1Q Median     3Q    Max 
## -4.588 -2.044 -0.042  1.505 10.685 
## 
## Coefficients:
##             Estimate Std. Error t value Pr(>|t|)    
## (Intercept)    2.949      0.607    4.86  8.7e-06 ***
## Pasthapp       0.273      0.103    2.66   0.0099 ** 
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 2.85 on 61 degrees of freedom
## Multiple R-squared:  0.104,	Adjusted R-squared:  0.0895 
## F-statistic:  7.1 on 1 and 61 DF,  p-value: 0.00987
```

```r

res1a_scaled = lm(Futurehapp ~ scale(Pasthapp, scale = FALSE), data = d0)
summary(res1a_scaled)
```

```
## 
## Call:
## lm(formula = Futurehapp ~ scale(Pasthapp, scale = FALSE), data = d0)
## 
## Residuals:
##    Min     1Q Median     3Q    Max 
## -4.588 -2.044 -0.042  1.505 10.685 
## 
## Coefficients:
##                                Estimate Std. Error t value Pr(>|t|)    
## (Intercept)                       4.254      0.359   11.86   <2e-16 ***
## scale(Pasthapp, scale = FALSE)    0.273      0.103    2.66   0.0099 ** 
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 2.85 on 61 degrees of freedom
## Multiple R-squared:  0.104,	Adjusted R-squared:  0.0895 
## F-statistic:  7.1 on 1 and 61 DF,  p-value: 0.00987
```

```r

# Visualize centered data
with(d0, plot(Futurehapp ~ scale(Pasthapp, scale = FALSE)))
abline(v = 0, col = "red")
```

![plot of chunk scaling](figure/scaling.png) 

```r

res1b = lm(Futurehapp ~ Responsible, data = d0)
summary(res1b)
```

```
## 
## Call:
## lm(formula = Futurehapp ~ Responsible, data = d0)
## 
## Residuals:
##    Min     1Q Median     3Q    Max 
## -4.877 -2.221  0.123  1.372 10.331 
## 
## Coefficients:
##             Estimate Std. Error t value Pr(>|t|)    
## (Intercept)    3.107      0.738    4.21  8.6e-05 ***
## Responsible    0.104      0.058    1.79    0.078 .  
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 2.93 on 61 degrees of freedom
## Multiple R-squared:  0.0501,	Adjusted R-squared:  0.0345 
## F-statistic: 3.22 on 1 and 61 DF,  p-value: 0.0778
```

```r

res2 = lm(Futurehapp ~ Pasthapp + Responsible, data = d0)
summary(res2)
```

```
## 
## Call:
## lm(formula = Futurehapp ~ Pasthapp + Responsible, data = d0)
## 
## Residuals:
##    Min     1Q Median     3Q    Max 
## -4.830 -1.941 -0.045  1.404 10.170 
## 
## Coefficients:
##             Estimate Std. Error t value Pr(>|t|)   
## (Intercept)    1.389      0.892    1.56   0.1246   
## Pasthapp       0.305      0.100    3.05   0.0034 **
## Responsible    0.128      0.055    2.32   0.0238 * 
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 2.75 on 60 degrees of freedom
## Multiple R-squared:  0.178,	Adjusted R-squared:  0.151 
## F-statistic: 6.49 on 2 and 60 DF,  p-value: 0.0028
```

```r

res2_scaled = lm(Futurehapp ~ scale(Pasthapp, scale = FALSE) + scale(Responsible, 
    scale = FALSE), data = d0)

summary(res2_scaled)
```

```
## 
## Call:
## lm(formula = Futurehapp ~ scale(Pasthapp, scale = FALSE) + scale(Responsible, 
##     scale = FALSE), data = d0)
## 
## Residuals:
##    Min     1Q Median     3Q    Max 
## -4.830 -1.941 -0.045  1.404 10.170 
## 
## Coefficients:
##                                   Estimate Std. Error t value Pr(>|t|)    
## (Intercept)                          4.254      0.346   12.28   <2e-16 ***
## scale(Pasthapp, scale = FALSE)       0.305      0.100    3.05   0.0034 ** 
## scale(Responsible, scale = FALSE)    0.128      0.055    2.32   0.0238 *  
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 2.75 on 60 degrees of freedom
## Multiple R-squared:  0.178,	Adjusted R-squared:  0.151 
## F-statistic: 6.49 on 2 and 60 DF,  p-value: 0.0028
```




