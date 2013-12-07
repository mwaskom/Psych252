Psych 252 Review
========================================================

Here we will analyze data from a study of 2287 eighth-grade pupils (aged about 11) in 132 classes in 131 schools in the Netherlands. 

The variables in the dataframe are:
- `lang`: language test score
- `IQ`: verbal IQ
- `class`: class ID
- `GS`: class size (number of eighth-grade pupils recorded in the class (there may be others see COMB, and some may have been omitted with missing values)
- `SES`: social-economic status of pupil's family
- `COMB`: were the pupils taught in a multi-grade class (0/1)? Classes which contained pupils from grades 7 and 8 are coded 1, but only eighth-graders were tested

Load in the data
----------------------

```r
library(ggplot2)
library(MASS)
data(nlschools)
data(n)  # use tab-complete to see details
```

```
## Warning: data set 'n' not found
```

```r
df = data.frame(nlschools)
str(df)
```

```
## 'data.frame':	2287 obs. of  6 variables:
##  $ lang : int  46 45 33 46 20 30 30 57 36 36 ...
##  $ IQ   : num  15 14.5 9.5 11 8 9.5 9.5 13 9.5 11 ...
##  $ class: Factor w/ 133 levels "180","280","1082",..: 1 1 1 1 1 1 1 1 1 1 ...
##  $ GS   : int  29 29 29 29 29 29 29 29 29 29 ...
##  $ SES  : int  23 10 15 23 10 10 23 10 13 15 ...
##  $ COMB : Factor w/ 2 levels "0","1": 1 1 1 1 1 1 1 1 1 1 ...
```

```r
# is everything factored correctly?
```


Take a quick look at relationships between some variables:
----------------------

```r
df_corr = data.frame(cbind(df$lang, df$IQ, df$SES, df$GS))
colnames(df_corr) = c("langScore", "IQ", "SES", "classSize")
z <- cor(df_corr)

require(lattice)
```

```
## Loading required package: lattice
```

```r
levelplot(z, panel = panel.levelplot.raster, par.settings = list(regions = list(col = heat.colors(100))))
```

![plot of chunk unnamed-chunk-2](figure/unnamed-chunk-2.png) 


Now, let's ask some questions, and examine them using our tools from stats!:
----------------------

### Does IQ predict language test score?

```r
library(lme4)
```

```
## Warning: package 'lme4' was built under R version 3.0.2
```

```
## Loading required package: Matrix
```

```
## Warning: package 'Matrix' was built under R version 3.0.2
```

```
## Attaching package: 'lme4'
## 
## The following object is masked from 'package:ggplot2':
## 
## fortify
```

```r
rs0 = lm(lang ~ scale(IQ, scale = FALSE), data = df)
summary(rs0)
```

```
## 
## Call:
## lm(formula = lang ~ scale(IQ, scale = FALSE), data = df)
## 
## Residuals:
##     Min      1Q  Median      3Q     Max 
## -28.702  -4.394   0.606   5.260  26.221 
## 
## Coefficients:
##                          Estimate Std. Error t value Pr(>|t|)    
## (Intercept)               40.9348     0.1492   274.3   <2e-16 ***
## scale(IQ, scale = FALSE)   2.6539     0.0722    36.8   <2e-16 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 7.14 on 2285 degrees of freedom
## Multiple R-squared:  0.372,	Adjusted R-squared:  0.372 
## F-statistic: 1.35e+03 on 1 and 2285 DF,  p-value: <2e-16
```

```r
rs1 = lmer(lang ~ scale(IQ, scale = FALSE) + (1 | class), data = df)
summary(rs1)
```

```
## Linear mixed model fit by REML ['lmerMod']
## Formula: lang ~ scale(IQ, scale = FALSE) + (1 | class) 
##    Data: df 
## 
## REML criterion at convergence: 15257 
## 
## Random effects:
##  Groups   Name        Variance Std.Dev.
##  class    (Intercept)  9.49    3.08    
##  Residual             42.25    6.50    
## Number of obs: 2287, groups: class, 133
## 
## Fixed effects:
##                          Estimate Std. Error t value
## (Intercept)               40.6004     0.3049   133.2
## scale(IQ, scale = FALSE)   2.4872     0.0701    35.5
## 
## Correlation of Fixed Effects:
##             (Intr)
## s(IQ,s=FALS 0.017
```

```r
rs2 = lmer(lang ~ scale(IQ, scale = FALSE) + (1 + IQ | class), data = df)

# test models..
anova(rs0, rs1)
```

```
## Error: $ operator not defined for this S4 class
```

```r
anova(rs1, rs2)
```

```
## Data: df
## Models:
## rs1: lang ~ scale(IQ, scale = FALSE) + (1 | class)
## rs2: lang ~ scale(IQ, scale = FALSE) + (1 + IQ | class)
##     Df   AIC   BIC logLik deviance Chisq Chi Df Pr(>Chisq)    
## rs1  4 15261 15284  -7626    15253                            
## rs2  6 15242 15277  -7615    15230  22.4      2    1.4e-05 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
```

```r

# or manually!
dev1 = -2 * as.numeric(logLik(rs0))
dev2 = -2 * as.numeric(logLik(rs1))

# get chisq p-stat (since diff in deviance has chi-sq distribution)
diff = dev1 - dev2
diff
```

```
## [1] 221
```

```r
4 - length(rs0$coefficients)
```

```
## [1] 2
```

```r
pchisq(diff, df = 2, lower.tail = FALSE)
```

```
## [1] 1.034e-48
```

```r

summary(rs2)
```

```
## Linear mixed model fit by REML ['lmerMod']
## Formula: lang ~ scale(IQ, scale = FALSE) + (1 + IQ | class) 
##    Data: df 
## 
## REML criterion at convergence: 15234 
## 
## Random effects:
##  Groups   Name        Variance Std.Dev. Corr 
##  class    (Intercept) 71.102   8.432         
##           IQ           0.241   0.491    -0.97
##  Residual             41.398   6.434         
## Number of obs: 2287, groups: class, 133
## 
## Fixed effects:
##                          Estimate Std. Error t value
## (Intercept)                40.704      0.303   134.4
## scale(IQ, scale = FALSE)    2.534      0.083    30.5
## 
## Correlation of Fixed Effects:
##             (Intr)
## s(IQ,s=FALS -0.364
```

```r
coef(rs2)
```

```
## $class
##               IQ (Intercept) scale(IQ, scale = FALSE)
## 180   -0.0342233       40.81                    2.534
## 280    0.6487651       28.04                    2.534
## 1082   0.5803927       29.99                    2.534
## 1280   0.3162070       34.60                    2.534
## 1580   0.7890646       25.51                    2.534
## 1680  -0.0615652       42.08                    2.534
## 1880   0.8767666       23.84                    2.534
## 2180   0.1767270       37.22                    2.534
## 2480  -0.3914297       48.65                    2.534
## 2680   0.0623295       38.98                    2.534
## 2780   0.5037918       30.00                    2.534
## 2980  -0.5328024       49.65                    2.534
## 3380   0.0917558       38.79                    2.534
## 3580  -0.0408965       41.55                    2.534
## 3680   0.5072181       30.76                    2.534
## 3880  -0.2074473       44.78                    2.534
## 4081   0.4566309       33.52                    2.534
## 4082  -0.2473713       45.03                    2.534
## 4180   0.4301154       32.49                    2.534
## 4280   0.6935666       28.01                    2.534
## 4480   0.3362514       34.60                    2.534
## 4780   0.4453902       31.40                    2.534
## 4880   0.2664701       35.51                    2.534
## 4980   0.4434356       32.70                    2.534
## 5280   0.2209517       34.42                    2.534
## 5480  -0.2266278       45.52                    2.534
## 5580  -0.2263456       43.72                    2.534
## 5780  -0.0918277       42.19                    2.534
## 6081   0.3885082       33.97                    2.534
## 6082   0.1590351       37.45                    2.534
## 6180   0.0362910       39.82                    2.534
## 6280  -0.4367020       48.09                    2.534
## 6580  -0.5788202       51.96                    2.534
## 6680   0.2856817       35.68                    2.534
## 6780   0.4864102       29.80                    2.534
## 6880   0.1604871       37.38                    2.534
## 7680   0.2286800       36.85                    2.534
## 7880  -0.1995701       43.34                    2.534
## 7980  -0.2279239       44.40                    2.534
## 8080   0.0170938       42.06                    2.534
## 8680  -0.0341708       41.46                    2.534
## 8780   0.2287162       36.99                    2.534
## 8880   0.3005439       36.47                    2.534
## 9080  -0.5369254       51.01                    2.534
## 9480  -0.4042818       47.62                    2.534
## 9580   0.1919551       36.72                    2.534
## 9780   0.0469386       40.51                    2.534
## 9880   0.1045879       37.61                    2.534
## 10180 -0.6002924       51.10                    2.534
## 10380  0.3527737       33.70                    2.534
## 10680  0.2397914       36.40                    2.534
## 10780  0.8073783       25.68                    2.534
## 10880  0.2706814       35.61                    2.534
## 10980  0.2266616       34.60                    2.534
## 11080 -0.3152288       46.49                    2.534
## 11180  0.0899525       39.16                    2.534
## 11282  0.0911277       39.29                    2.534
## 11580  0.1750936       37.75                    2.534
## 11680  0.3482142       33.72                    2.534
## 11880  0.5256794       30.94                    2.534
## 11980  0.1761190       37.08                    2.534
## 12180  0.3720583       32.90                    2.534
## 12380 -0.1818146       43.25                    2.534
## 12480 -0.3839006       47.82                    2.534
## 12580 -0.0690690       42.27                    2.534
## 13080 -0.1595484       45.12                    2.534
## 13281 -0.4148737       49.44                    2.534
## 13680 -0.3953266       48.81                    2.534
## 13780 -0.3310953       47.57                    2.534
## 14180 -0.0047832       40.50                    2.534
## 14280 -0.4199310       49.05                    2.534
## 14780 -0.6998984       54.70                    2.534
## 14880 -0.2658562       45.48                    2.534
## 14980 -0.1083104       43.04                    2.534
## 15080  0.0007784       41.26                    2.534
## 15180 -0.0960538       42.16                    2.534
## 15280 -0.5935805       52.61                    2.534
## 15580 -0.1431650       45.05                    2.534
## 15680  0.0604860       39.53                    2.534
## 15980 -0.2226230       45.06                    2.534
## 16080 -0.0703156       43.41                    2.534
## 16180 -0.5738647       51.51                    2.534
## 16480 -0.3452187       47.75                    2.534
## 16780 -0.3962563       48.07                    2.534
## 17080  0.2187152       39.24                    2.534
## 17580 -0.1298093       43.70                    2.534
## 17680 -0.3374420       48.99                    2.534
## 17780 -0.0909319       42.16                    2.534
## 17980  0.7284331       26.78                    2.534
## 18280 -0.0723874       42.03                    2.534
## 18380  0.0169905       40.54                    2.534
## 18480 -0.3182605       44.93                    2.534
## 18880  0.2612982       36.24                    2.534
## 18980 -0.1762071       44.27                    2.534
## 19280  0.3649380       33.62                    2.534
## 19380 -0.4899758       50.74                    2.534
## 19580  0.1167568       38.67                    2.534
## 19680 -0.1671692       43.74                    2.534
## 19780 -0.0407095       41.38                    2.534
## 19880  0.2551369       35.94                    2.534
## 19980  0.4893622       31.03                    2.534
## 20480 -0.0997386       42.49                    2.534
## 20680 -0.1580711       44.29                    2.534
## 20980 -0.1220502       43.45                    2.534
## 21080  0.2281934       36.76                    2.534
## 21280 -0.2834526       45.25                    2.534
## 21480  0.2441145       34.51                    2.534
## 21580 -0.2183823       44.64                    2.534
## 21680 -0.1093830       42.86                    2.534
## 21780 -0.0630526       42.40                    2.534
## 21880 -0.8381030       55.34                    2.534
## 21980 -0.5658305       51.06                    2.534
## 22280  0.0776493       39.93                    2.534
## 22480 -0.1090418       42.11                    2.534
## 22680 -0.0201778       40.48                    2.534
## 22780 -0.4538976       48.33                    2.534
## 22880 -0.9388615       58.38                    2.534
## 23180 -0.5773561       51.75                    2.534
## 23380  0.4219122       33.08                    2.534
## 23480 -0.2698277       46.63                    2.534
## 23580 -0.0850648       43.21                    2.534
## 23780 -0.1830995       43.83                    2.534
## 24080 -0.0050381       40.57                    2.534
## 24180 -0.1385025       43.49                    2.534
## 24280 -0.3522376       48.04                    2.534
## 24380 -0.4344185       48.73                    2.534
## 24480  0.0906330       38.87                    2.534
## 24680 -0.0630685       42.89                    2.534
## 24980 -0.0342654       41.07                    2.534
## 25080 -0.0030211       40.45                    2.534
## 25280 -0.1094545       41.67                    2.534
## 25680  0.9463627       23.80                    2.534
## 25880  0.6501759       27.83                    2.534
## 
## attr(,"class")
## [1] "coef.mer"
```


### Does IQ predict language test score, when controlling for SES?

```r
rs3 = lmer(lang ~ scale(IQ, scale = FALSE) + scale(SES, scale = FALSE) + (1 | 
    class), data = df)
summary(rs3)
```

```
## Linear mixed model fit by REML ['lmerMod']
## Formula: lang ~ scale(IQ, scale = FALSE) + scale(SES, scale = FALSE) +      (1 | class) 
##    Data: df 
## 
## REML criterion at convergence: 15141 
## 
## Random effects:
##  Groups   Name        Variance Std.Dev.
##  class    (Intercept)  9.16    3.03    
##  Residual             40.03    6.33    
## Number of obs: 2287, groups: class, 133
## 
## Fixed effects:
##                           Estimate Std. Error t value
## (Intercept)                40.6616     0.2990   136.0
## scale(IQ, scale = FALSE)    2.2518     0.0714    31.5
## scale(SES, scale = FALSE)   0.1661     0.0148    11.2
## 
## Correlation of Fixed Effects:
##             (Intr) s(Is=F
## s(IQ,s=FALS  0.011       
## s(SES,s=FAL  0.019 -0.293
```


### Is there an interaction between IQ and SES predicting language test score?

```r
with(df, coplot(lang ~ scale(IQ, scale = FALSE) | scale(SES, scale = FALSE), number = 3, rows = 1, overlap=0))
```

![plot of chunk unnamed-chunk-5](figure/unnamed-chunk-51.png) 

```r

with(df, coplot(lang ~ scale(SES, scale = FALSE) | scale(IQ, scale = FALSE), number = 3, rows = 1, overlap=0))
```

![plot of chunk unnamed-chunk-5](figure/unnamed-chunk-52.png) 

```r


rs3_inter = lmer(lang ~ scale(IQ) * scale(SES) + (1 |class), data = df)
summary(rs3_inter)
```

```
## Linear mixed model fit by REML ['lmerMod']
## Formula: lang ~ scale(IQ) * scale(SES) + (1 | class) 
##    Data: df 
## 
## REML criterion at convergence: 15130 
## 
## Random effects:
##  Groups   Name        Variance Std.Dev.
##  class    (Intercept)  8.98    3.00    
##  Residual             39.97    6.32    
## Number of obs: 2287, groups: class, 133
## 
## Fixed effects:
##                      Estimate Std. Error t value
## (Intercept)            40.781      0.300   135.9
## scale(IQ)               4.621      0.148    31.2
## scale(SES)              1.843      0.162    11.4
## scale(IQ):scale(SES)   -0.342      0.134    -2.6
## 
## Correlation of Fixed Effects:
##             (Intr) sc(IQ) s(SES)
## scale(IQ)   -0.005              
## scale(SES)   0.030 -0.298       
## s(IQ):(SES) -0.154  0.102 -0.076
```

```r

# Look into this interaction some more!
# Simple slope at scale(SES) + 1SD
rs3_hiSES = lmer(lang ~ scale(IQ) * I(scale(SES) - 1) + (1 |class), data = df)
summary(rs3_hiSES)
```

```
## Linear mixed model fit by REML ['lmerMod']
## Formula: lang ~ scale(IQ) * I(scale(SES) - 1) + (1 | class) 
##    Data: df 
## 
## REML criterion at convergence: 15130 
## 
## Random effects:
##  Groups   Name        Variance Std.Dev.
##  class    (Intercept)  8.98    3.00    
##  Residual             39.97    6.32    
## Number of obs: 2287, groups: class, 133
## 
## Fixed effects:
##                             Estimate Std. Error t value
## (Intercept)                   42.624      0.345   123.5
## scale(IQ)                      4.279      0.210    20.4
## I(scale(SES) - 1)              1.843      0.162    11.4
## scale(IQ):I(scale(SES) - 1)   -0.342      0.134    -2.6
## 
## Correlation of Fixed Effects:
##             (Intr) sc(IQ) I((S-1
## scale(IQ)   -0.210              
## I(s(SES)-1)  0.495 -0.260       
## s(IQ):I((-1 -0.169  0.710 -0.076
```

```r

rs3_loSES = lmer(lang ~ scale(IQ) * I(scale(SES) + 1) + (1 |class), data = df)
summary(rs3_loSES)
```

```
## Linear mixed model fit by REML ['lmerMod']
## Formula: lang ~ scale(IQ) * I(scale(SES) + 1) + (1 | class) 
##    Data: df 
## 
## REML criterion at convergence: 15130 
## 
## Random effects:
##  Groups   Name        Variance Std.Dev.
##  class    (Intercept)  8.98    3.00    
##  Residual             39.97    6.32    
## Number of obs: 2287, groups: class, 133
## 
## Fixed effects:
##                             Estimate Std. Error t value
## (Intercept)                   38.939      0.337   115.7
## scale(IQ)                      4.964      0.189    26.2
## I(scale(SES) + 1)              1.843      0.162    11.4
## scale(IQ):I(scale(SES) + 1)   -0.342      0.134    -2.6
## 
## Correlation of Fixed Effects:
##             (Intr) sc(IQ) I((S+1
## scale(IQ)    0.180              
## I(s(SES)+1) -0.453 -0.180       
## s(IQ):I((+1 -0.100 -0.626 -0.076
```

```r

ggplot(df, 
       aes(x=scale(IQ), 
           y=SES)) +  # Adding color
  geom_point(shape=1) +  
  theme_bw() + 
  # effect of IQ @mean SES
  geom_abline(aes(intercept=40.7814, slope=4.6214), colour='black') +
  # effect of IQ on  @+1SD SES
  geom_abline(aes(intercept=42.6243, slope=4.2792), colour='green') +
  # effect of IQ on  @-1SD SES
  geom_abline(aes(intercept=38.9386, slope=4.9637), colour='red')+
  ggtitle('Interaction between SES and IQ on Language Test Scores')
```

![plot of chunk unnamed-chunk-5](figure/unnamed-chunk-53.png) 

What might you do to test if adding random effects for the slopes improves the model?


### Does combined class predict language test score?

```r
df$COMB_fac = factor(df$COMB)
levels(df$COMB_fac)
```

```
## [1] "0" "1"
```

```r

rs4 = lmer(lang ~ COMB_fac + (1 | class), data = df)
summary(rs4)
```

```
## Linear mixed model fit by REML ['lmerMod']
## Formula: lang ~ COMB_fac + (1 | class) 
##    Data: df 
## 
## REML criterion at convergence: 16239 
## 
## Random effects:
##  Groups   Name        Variance Std.Dev.
##  class    (Intercept) 17.7     4.21    
##  Residual             64.5     8.03    
## Number of obs: 2287, groups: class, 133
## 
## Fixed effects:
##             Estimate Std. Error t value
## (Intercept)   41.542      0.519    80.0
## COMB_fac1     -3.048      0.840    -3.6
## 
## Correlation of Fixed Effects:
##           (Intr)
## COMB_fac1 -0.617
```

```r

contrasts(df$COMB_fac) = c(1, -1)
# contrasts(df$COMB_fac) = c(-1, 1) contrasts(df$COMB_fac) = c(0, 1)
contrasts(df$COMB_fac)
```

```
##   [,1]
## 0    1
## 1   -1
```

```r
rs4_v2 = lmer(lang ~ COMB_fac + (1 | class), data = df)
summary(rs4)
```

```
## Linear mixed model fit by REML ['lmerMod']
## Formula: lang ~ COMB_fac + (1 | class) 
##    Data: df 
## 
## REML criterion at convergence: 16239 
## 
## Random effects:
##  Groups   Name        Variance Std.Dev.
##  class    (Intercept) 17.7     4.21    
##  Residual             64.5     8.03    
## Number of obs: 2287, groups: class, 133
## 
## Fixed effects:
##             Estimate Std. Error t value
## (Intercept)   41.542      0.519    80.0
## COMB_fac1     -3.048      0.840    -3.6
## 
## Correlation of Fixed Effects:
##           (Intr)
## COMB_fac1 -0.617
```

```r

plot(lang ~ COMB_fac, data = df)
```

![plot of chunk unnamed-chunk-6](figure/unnamed-chunk-6.png) 

```r
aggregate(lang ~ COMB_fac, data = df, mean)
```

```
##   COMB_fac  lang
## 1        0 41.60
## 2        1 39.18
```


### Are there similar numbers of students observed from each class?

```r
tb = table(df$class)
tb
```

```
## 
##   180   280  1082  1280  1580  1680  1880  2180  2480  2680  2780  2980 
##    25     7     5    15     8     8    24    17    24    18    21    10 
##  3380  3580  3680  3880  4081  4082  4180  4280  4480  4780  4880  4980 
##     6    14    23    28    25    10    13    14    15     8    11     9 
##  5280  5480  5580  5780  6081  6082  6180  6280  6580  6680  6780  6880 
##    21    31    30    24    10    12    20    21    22    11    26    20 
##  7680  7880  7980  8080  8680  8780  8880  9080  9480  9580  9780  9880 
##    16    17    14    21    24    21    10    15    15    18    17    20 
## 10180 10380 10680 10780 10880 10980 11080 11180 11282 11580 11680 11880 
##    23     4    10    17     9    20    17    18     7    30    19     9 
## 11980 12180 12380 12480 12580 13080 13281 13680 13780 14180 14280 14780 
##    12    10     4    20    26    13    21    16    18    20    24    22 
## 14880 14980 15080 15180 15280 15580 15680 15980 16080 16180 16480 16780 
##    29    21    25    23    17    33    12    31    23    31    24    25 
## 17080 17580 17680 17780 17980 18280 18380 18480 18880 18980 19280 19380 
##    26    14    23    17     6     9    31    28    12    17     8    12 
## 19580 19680 19780 19880 19980 20480 20680 20980 21080 21280 21480 21580 
##    20    27    20     7    30    24    11    23    16    25    21    12 
## 21680 21780 21880 21980 22280 22480 22680 22780 22880 23180 23380 23480 
##     7     8    24    14    24    13     8    18    21    21     9    13 
## 23580 23780 24080 24180 24280 24380 24480 24680 24980 25080 25280 25680 
##    10    15    12    23    11     8    13    12    24    15    11    10 
## 25880 
##     7
```

```r
chisq.test(tb)
```

```
## 
## 	Chi-squared test for given probabilities
## 
## data:  tb
## X-squared = 387.2, df = 132, p-value < 2.2e-16
```


### Were there similar numbers of students from combined/not combined classes?

```r
tb = table(df$COMB)
tb
```

```
## 
##    0    1 
## 1658  629
```

```r
chisq.test(tb)
```

```
## 
## 	Chi-squared test for given probabilities
## 
## data:  tb
## X-squared = 463, df = 1, p-value < 2.2e-16
```

```r
prop.table(tb)
```

```
## 
##     0     1 
## 0.725 0.275
```


### Does SES predict whether or not a student is in a combined class?

```r
rs_glm = glmer(COMB ~ scale(SES) + (1 | class), family = "binomial", data = df)
rs2_glm = glmer(COMB ~ scale(SES) + (1 + SES | class), family = "binomial", 
    data = df)
```

```
## Error: (maxstephalfit) PIRLS step-halvings failed to reduce deviance in
## pwrssUpdate
```

```r
anova(rs_glm, rs2_glm)
```

```
## Error: object 'rs2_glm' not found
```

```r
summary(rs2_glm)
```

```
## Error: error in evaluating the argument 'object' in selecting a method for
## function 'summary': Error: object 'rs2_glm' not found
```


### SES as a categorical variable

```r
quantpf3 = quantile(df$SES, probs = c(0.34, 0.66))

df$SEScat = findInterval(df$SES, quantpf3)
df$SEScat <- factor(df$SEScat, labels = c("LoSES", "MidSES", "HiSES"))
table(df$SEScat)
```

```
## 
##  LoSES MidSES  HiSES 
##    467    807   1013
```

```r

aggregate(SES ~ df$SEScat, data = df, mean)
```

```
##   df$SEScat   SES
## 1     LoSES 14.52
## 2    MidSES 22.51
## 3     HiSES 38.17
```


### Is being in a combined class related to SES?

```r
tb = table(df$COMB, df$SEScat)
tb
```

```
##    
##     LoSES MidSES HiSES
##   0   316    586   756
##   1   151    221   257
```

```r
chisq.test(tb)
```

```
## 
## 	Pearson's Chi-squared test
## 
## data:  tb
## X-squared = 7.783, df = 2, p-value = 0.02041
```

```r

prop.table(tb)
```

```
##    
##       LoSES  MidSES   HiSES
##   0 0.13817 0.25623 0.33056
##   1 0.06603 0.09663 0.11237
```

```r
addmargins(tb)
```

```
##      
##       LoSES MidSES HiSES  Sum
##   0     316    586   756 1658
##   1     151    221   257  629
##   Sum   467    807  1013 2287
```

```r

# % of kids in non-combined class by SES category
316/467
```

```
## [1] 0.6767
```

```r
586/807
```

```
## [1] 0.7261
```

```r
756/1013
```

```
## [1] 0.7463
```


