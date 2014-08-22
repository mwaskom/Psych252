Bootstrapping Example
========================================================
Bootstrap scripts written by Desmond Ong (dco@stanford), converted to R Markdown by Steph Gagnon

Load in $doBootstrap$ functions:
-------------------------------

```r
source("https://github.com/desmond-ong/doBootstrap/blob/master/doBootstrap.R")
```

```
## Warning: unsupported URL scheme
```

```
## Error: cannot open the connection
```


doBoot is the basic function that calculates descriptive statistics. For example, you can use the following format:

> results <- doBoot(x, y=NULL, mediator=NULL, whichTest = "mean", numberOfIterations = 5000, confidenceInterval=.95, na.rm=TRUE)


# results <- doBoot(x, y=NULL, mediator=NULL, whichTest = "mean", numberOfIterations = 5000, 
# confidenceInterval=.95, na.rm=TRUE)
#
# Output: Results
#
# Input:
#   x = first data vector. Feed in a VECTOR!
#   y = second data vector (not necessary if you're doing statistics on one data vector only, e.g. mean)
#   mediator = mediator data vector (if you want to do mediation)
#   whichTest = the test you want to do, as a string. 
#       Currently the tests supported are:
#           "mean" (single vector test)
#           "correlation" (correlation between two vectors, paired)
#           "difference, unpaired" (difference between two vectors, unpaired)
#           "difference, paired" (difference between two vectors, paired)
#           "cohen, unpaired" (basically unpaired difference / pooled standard dev) * not bias corrected nor accelerated
#           "cohen, paired" (basically paired difference / standard deviation) * not bias corrected nor accelerated
#           "mediation" (calculates a x-->y, x-->med-->y mediation, using Benoit's bm.bootmed code)
#               basically just feeds into Benoit's code for now.
#           "custom function": allows you to supply your own function, such that the desired statistic
#               is customFunction(x) or customFunction(x,y) if y is supplied.
#               Warning: doBoot doesn't test if you have supplied the correct number of arguments. It'll just try to call it.
#
#
#   numberOfIterations = number of bootstrapping iterations. Default is 5000
#   confidenceInterval = specifies the percentile of the CI. Default is .95
#   na.rm = remove NAs?
#

# using the mtcars dataset

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

```r
# resultsMean <- doBoot(mtcars$mpg)
resultsMean <- doBoot(mtcars$mpg, whichTest = "mean")
```

```
## Error: could not find function "doBoot"
```

```r
resultsCorrelation <- doBoot(mtcars$disp, mtcars$hp, whichTest = "correlation")
```

```
## Error: could not find function "doBoot"
```

```r
resultsDifference <- doBoot(mtcars$disp, mtcars$hp, whichTest = "difference, unpaired")
```

```
## Error: could not find function "doBoot"
```

```r
resultsDifference <- doBoot(mtcars$disp, mtcars$hp, whichTest = "difference, paired")
```

```
## Error: could not find function "doBoot"
```

```r
resultsCohen <- doBoot(mtcars$disp, mtcars$hp, whichTest = "cohen, unpaired")
```

```
## Error: could not find function "doBoot"
```

```r
resultsCohen <- doBoot(mtcars$disp, mtcars$hp, whichTest = "cohen, paired")
```

```
## Error: could not find function "doBoot"
```


# just using Benoit's code off the bat...

```r
resultsMediation <- doBoot(mtcars$disp, mtcars$hp, mtcars$cyl, whichTest = "mediation")
```

```
## Error: could not find function "doBoot"
```



# # doBootRegression is the function you call if you want to bootstrap regressions.
#
# results <- doBootRegression(dataset, formula, mixedEffects = FALSE, numberOfIterations = 5000, 
# confidenceInterval=.95, na.rm=TRUE)
#
# Output: Results
#
# Input:
#   dataset = input dataset
#   formula = the regression formula of interest. For e.g., "y ~ x" or "y ~ x + (1|z)"
#   mixedEffects = whether your formula has mixed effects. Default FALSE.
#       If true, will use lmer, otherwise, lm. 
#       For lmer, will output only fixed effect coefficients
#       For lm, will output coefficients, and R^2
#   numberOfIterations = number of bootstrapping iterations. Default is 5000
#   confidenceInterval = specifies the percentile of the CI. Default is .95
#   na.rm = remove NAs?


```r
resultsRegression <- doBootRegression(mtcars, disp ~ hp)
```

```
## Error: could not find function "doBootRegression"
```

```r
resultsRegression <- doBootRegression(mtcars, disp ~ hp + (1 | cyl), mixedEffects = TRUE)
```

```
## Error: could not find function "doBootRegression"
```




