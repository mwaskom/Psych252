Bootstrapping Example
========================================================
Bootstrap scripts written by Desmond Ong (dco@stanford), converted to R Markdown by Steph Gagnon

Load in `doBootstrap` functions:
-------------------------------

```r
source("http://www.stanford.edu/class/psych252/tutorials/doBootstrap.R")
```


`doBoot` is the basic function that calculates descriptive statistics. For example, you can use the following format:

> results <- doBoot(x, y=NULL, mediator=NULL, whichTest = "mean", numberOfIterations = 5000, confidenceInterval=.95, na.rm=TRUE)

**Output:**

- **Results**

**Input:**

+ **x** = first data vector. Feed in a VECTOR!
+ **y** = second data vector (not necessary if you're doing statistics on one data vector only, e.g. mean)
+ **mediator** = mediator data vector (if you want to do mediation)
+ **whichTest** = the test you want to do, as a string.
    - "mean" (single vector test)
    - "correlation" (correlation between two vectors, paired)
    - "difference, unpaired" (difference between two vectors, unpaired)
    - "difference, paired" (difference between two vectors, paired)
    - "cohen, unpaired" (basically unpaired difference / pooled standard dev) * not bias corrected   nor accelerated
    - "mediation" (calculates a x-->y, x-->med-->y mediation, using Benoit's bm.bootmed code)
    - "custom function": allows you to supply your own function, such that the desired statistic is customFunction(x) or customFunction(x,y) if y is supplied.
+ **numberOfIterations** = number of bootstrapping iterations. Default is 5000
+ **confidenceInterval** = specifies the percentile of the CI. Default is .95
+ **na.rm** = remove NAs?

Some examples with mtcars dataset
------------------------------
First, let's load in the $mtcars$ dataset

```r
head(mtcars)
```

```
##                    mpg cyl disp  hp drat    wt  qsec vs am gear carb
## Mazda RX4         21.0   6  160 110 3.90 2.620 16.46  0  1    4    4
## Mazda RX4 Wag     21.0   6  160 110 3.90 2.875 17.02  0  1    4    4
## Datsun 710        22.8   4  108  93 3.85 2.320 18.61  1  1    4    1
## Hornet 4 Drive    21.4   6  258 110 3.08 3.215 19.44  1  0    3    1
## Hornet Sportabout 18.7   8  360 175 3.15 3.440 17.02  0  0    3    2
## Valiant           18.1   6  225 105 2.76 3.460 20.22  1  0    3    1
```


### Bootstrapping the Mean
Now, let's try bootstrapping the mean miles per gallon ($mpg$) of the cars in the mtcars dataset.  Note that if you don't provide an argument to $whichTest$ the function won't run!

```r
# resultsMean <- doBoot(mtcars$mpg) #error!
resultsMean <- doBoot(mtcars$mpg, whichTest = "mean")
```

```
## Performing bootstrap with whichTest *** mean ***
## | +                   | 10 % completed 
## | + +                 | 20 % completed 
## | + + +               | 30 % completed 
## | + + + +             | 40 % completed 
## | + + + + +           | 50 % completed 
## | + + + + + +         | 60 % completed 
## | + + + + + + +       | 70 % completed 
## | + + + + + + + +     | 80 % completed 
## | + + + + + + + + +   | 90 % completed 
## | + + + + + + + + + + | 100 % completed 
## Results using 5000 iterations, and a 0.95 CI 
## whichTest used is: ***  mean *** in the form: Result, [low end of CI, high end of CI]
## 20.06 [ 18.04 , 22.14 ]
```

Here, we can see that the bootstrapped estimate for mean miles per gallon is 20.0625, and the 95% confidence interval of this estimate is from 18.0405 to 22.1441.

If we compare this to the actual data, we can see that the bootstrapped mean and 95% CI closely match that observed in the data.

```r
boxplot(mtcars$mpg, notch = TRUE, col = "dodgerblue", ylab = "mpg")
```

![plot of chunk unnamed-chunk-4](figure/unnamed-chunk-4.png) 



### Bootstrap a correlation:

```r
resultsCorrelation <- doBoot(mtcars$disp, mtcars$hp, whichTest = "correlation")
```

```
## Performing bootstrap with whichTest *** correlation ***
## | +                   | 10 % completed 
## | + +                 | 20 % completed 
## | + + +               | 30 % completed 
## | + + + +             | 40 % completed 
## | + + + + +           | 50 % completed 
## | + + + + + +         | 60 % completed 
## | + + + + + + +       | 70 % completed 
## | + + + + + + + +     | 80 % completed 
## | + + + + + + + + +   | 90 % completed 
## | + + + + + + + + + + | 100 % completed 
## Results using 5000 iterations, and a 0.95 CI 
## whichTest used is: ***  correlation *** in the form: Result, [low end of CI, high end of CI]
## 0.8028 [ 0.6729 , 0.9084 ]
```

Here we bootstrapped a correlation between cars' displacement (`disp`) and gross horsepower (`hp`). The function returned an estimated correlation of 0.8028 with a 95% CI from 0.6729 to 0.9084.

Let's observe the correlation using the data in our sample:

```r
plot(mtcars$disp, mtcars$hp, col = "firebrick", pch = 16)
```

![plot of chunk unnamed-chunk-6](figure/unnamed-chunk-6.png) 



### Bootstap a difference between Means
Next, let's bootstrap the **difference** between the mean displacement and horsepower. Here, we can either treat the values as **unpaired** (i.e., coming from independent sources), or **paired** (i.e., both values come from the same car). First, let's check out the data:

```r
boxplot(mtcars$disp, mtcars$hp, names = c("disp", "hp"), col = c("mediumseagreen", 
    "mediumvioletred"))
```

![plot of chunk unnamed-chunk-7](figure/unnamed-chunk-7.png) 


Now let's estimate the difference between the mean displacement and horsepower:

```r
resultsDifference_u <- doBoot(mtcars$disp, mtcars$hp, whichTest = "difference, unpaired")
```

```
## Performing bootstrap with whichTest *** difference, unpaired ***
## | +                   | 10 % completed 
## | + +                 | 20 % completed 
## | + + +               | 30 % completed 
## | + + + +             | 40 % completed 
## | + + + + +           | 50 % completed 
## | + + + + + +         | 60 % completed 
## | + + + + + + +       | 70 % completed 
## | + + + + + + + +     | 80 % completed 
## | + + + + + + + + +   | 90 % completed 
## | + + + + + + + + + + | 100 % completed 
## Results using 5000 iterations, and a 0.95 CI 
## whichTest used is: ***  difference, unpaired *** in the form: Result, [low end of CI, high end of CI]
## 83.19 [ 36.58 , 131.3 ]
```

```r
resultsDifference_p <- doBoot(mtcars$disp, mtcars$hp, whichTest = "difference, paired")
```

```
## Performing bootstrap with whichTest *** difference, paired ***
## | +                   | 10 % completed 
## | + +                 | 20 % completed 
## | + + +               | 30 % completed 
## | + + + +             | 40 % completed 
## | + + + + +           | 50 % completed 
## | + + + + + +         | 60 % completed 
## | + + + + + + +       | 70 % completed 
## | + + + + + + + +     | 80 % completed 
## | + + + + + + + + +   | 90 % completed 
## | + + + + + + + + + + | 100 % completed 
## Results using 5000 iterations, and a 0.95 CI 
## whichTest used is: ***  difference, paired *** in the form: Result, [low end of CI, high end of CI]
## 83.97 [ 57.65 , 112.9 ]
```


Here, we can see that both tests calculate a similar difference in means (diff = 83.1937, 36.5837, 131.3427), but different confidence intervals. Assuming the mean displacement and horsepower are **unpaired**, the 95% CI is larger, 36.5837 - 131.3427, whereas when we take into account that our observations of displacement and horsepower come from the same car (i.e., **paired**), the 95% CI is smaller 57.6548 - 112.8908. Neither 95% CI overlaps with zero, and so we might reject the null hypothesis that the difference between the mean displacement and mean horsepower is equal to zero; in other words, it appears that the mean displacement is higher than the mean horsepower. 

### Bootstrap Cohen's D

```r
resultsCohen <- doBoot(mtcars$disp, mtcars$hp, whichTest = "cohen, unpaired")
```

```
## Performing bootstrap with whichTest *** cohen, unpaired ***
## | +                   | 10 % completed 
## | + +                 | 20 % completed 
## | + + +               | 30 % completed 
## | + + + +             | 40 % completed 
## | + + + + +           | 50 % completed 
## | + + + + + +         | 60 % completed 
## | + + + + + + +       | 70 % completed 
## | + + + + + + + +     | 80 % completed 
## | + + + + + + + + +   | 90 % completed 
## | + + + + + + + + + + | 100 % completed 
## Results using 5000 iterations, and a 0.95 CI 
## whichTest used is: ***  cohen, unpaired *** in the form: Result, [low end of CI, high end of CI]
## 0.8476 [ 0.3755 , 1.343 ]
```

```r
resultsCohen <- doBoot(mtcars$disp, mtcars$hp, whichTest = "cohen, paired")
```

```
## Performing bootstrap with whichTest *** cohen, paired ***
## | +                   | 10 % completed 
## | + +                 | 20 % completed 
## | + + +               | 30 % completed 
## | + + + +             | 40 % completed 
## | + + + + +           | 50 % completed 
## | + + + + + +         | 60 % completed 
## | + + + + + + +       | 70 % completed 
## | + + + + + + + +     | 80 % completed 
## | + + + + + + + + +   | 90 % completed 
## | + + + + + + + + + + | 100 % completed 
## Results using 5000 iterations, and a 0.95 CI 
## whichTest used is: ***  cohen, paired *** in the form: Result, [low end of CI, high end of CI]
## 1.052 [ 0.7762 , 1.395 ]
```


### Bootstrap Mediation using Benoit's code

```r
resultsMediation <- doBoot(mtcars$disp, mtcars$hp, mtcars$cyl, whichTest = "mediation")
```

```
## Performing bootstrap with whichTest *** mediation ***
```

![plot of chunk unnamed-chunk-10](figure/unnamed-chunk-10.png) 

```
##           c    c'     a      b    ab Sobel Goodman
## Coeff 0.438 0.119 0.013 24.515 0.319 2.634   2.653
## p val 0.000 0.368 0.000  0.011    NA 0.008   0.008
## [1] Bootstrap results:
## Mean(ab*) p(ab*<ab) 
##     0.318     0.542 
## [1] Uncorrected:
##  2.5% 97.5% 
## 0.123 0.573 
## [1] Bias Corrected:
##    4% 98.5% 
## 0.139 0.610 
## Results using 5000 iterations, and a 0.95 CI 
## whichTest used is: ***  mediation *** in the form: Result, [low end of CI, high end of CI]
## 0 [ 0 , 0 ]
```



Bootstrapping Regressions with `doBootRegression`
---------------------------
`doBootRegression` is the function you call if you want to bootstrap regressions.

> results <- doBootRegression(dataset, formula, mixedEffects = FALSE, numberOfIterations = 5000, confidenceInterval=.95, na.rm=TRUE)

**Output:**
+ **Results**

**Input:**
+ **dataset** = input dataset
+ **formula** = the regression formula of interest. For e.g., "y ~ x" or "y ~ x + (1|z)"
+ **mixedEffects** = whether your formula has mixed effects. Default FALSE.
    - If true, will use lmer, otherwise, lm. 
    - For lmer, will output only fixed effect coefficients
    - For lm, will output coefficients, and R^2
+ **numberOfIterations** = number of bootstrapping iterations. Default is 5000
+ **confidenceInterval** = specifies the percentile of the CI. Default is .95
+ **na.rm** = remove NAs?


```r
resultsRegression <- doBootRegression(mtcars, disp ~ hp)
```

```
## If it throws a subscript out of bounds error, it could be because of singularities in the lm. To be fixed
## | +                   | 10 % completed 
## | + +                 | 20 % completed 
## | + + +               | 30 % completed 
## | + + + +             | 40 % completed 
## | + + + + +           | 50 % completed 
## | + + + + + +         | 60 % completed 
## | + + + + + + +       | 70 % completed 
## | + + + + + + + +     | 80 % completed 
## | + + + + + + + + +   | 90 % completed 
## | + + + + + + + + + + | 100 % completed 
## Bootstrapped regression results using 5000 iterations, and a 0.95 CI 
## Results are in the form: Result, [low end of CI, high end of CI]
## R squared: 0.6451 [ 0.4605 , 0.8272 ]
## Coefficient : (Intercept) 16.63 [ -63.37 , 80.41 ]
## Coefficient : hp 1.45 [ 0.9844 , 2.14 ]
```

```r
# resultsRegression <- doBootRegression(mtcars, disp~hp+(1|cyl),
# mixedEffects = TRUE)
```




