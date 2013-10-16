<style> div.largefont {font-size:200%}</style>

Logistic Regression Tutorial
========================================================

Look at the data
-----------------

To get started, let's load in a dataset (info about the variables can be found [here](http://stanford.edu/class/psych252/):


```r
d0 = read.csv("http://www.stanford.edu/class/psych252/data/hw2data.csv")
summary(d0)
```

```
##       Type         Pasthapp      Responsible   Futurehapp   
##  Min.   :1.00   Min.   : 0.00   Min.   : 0   Min.   : 0.00  
##  1st Qu.:1.00   1st Qu.: 2.00   1st Qu.: 5   1st Qu.: 2.00  
##  Median :2.00   Median : 4.00   Median :14   Median : 5.00  
##  Mean   :1.94   Mean   : 4.78   Mean   :11   Mean   : 4.25  
##  3rd Qu.:3.00   3rd Qu.: 7.00   3rd Qu.:16   3rd Qu.: 5.00  
##  Max.   :3.00   Max.   :15.00   Max.   :20   Max.   :15.00  
##       FTP          complain    
##  Min.   : 3.0   Min.   :0.000  
##  1st Qu.:10.0   1st Qu.:0.000  
##  Median :13.0   Median :0.000  
##  Mean   :12.4   Mean   :0.476  
##  3rd Qu.:15.0   3rd Qu.:1.000  
##  Max.   :19.0   Max.   :1.000
```

```r

# factor d0$Type (i.e., memory groups), since it is categorical
d0$Type = factor(d0$Type)
head(d0)
```

```
##   Type Pasthapp Responsible Futurehapp FTP complain
## 1    2        2          10          5  12        1
## 2    3       10           5          5  18        1
## 3    1        2          18          3   9        0
## 4    3        5          15          0  15        1
## 5    1        7          17          7  17        1
## 6    1        0          20          5  15        0
```


We can see that the variable `d0$complain` takes on values of 1 or 0. Here, 1 and 0 code for YES/NO responses for whether or not a participant considers complaining (1=YES, 2=NO).

Now, we might be interested in whether or not a participant's **self-reported feelings of responsibility** of missing a plane or a train (`d0$Responsible`) influences whether or not they **considered complaining** (`d0$complain`).

First, let's take a look at the data in a few different ways:

```r
plot(factor(d0$complain), d0$Responsible, xlab = ("Considered Complaining (0=NO, 1=YES)"), 
    ylab = "Feeling of Responsibility")
```

![plot of chunk plot_complainXresponsible](figure/plot_complainXresponsible1.png) 

```r

plot(jitter(d0$complain, factor = 0.5) ~ d0$Responsible, ylab = "Considered Complaining (0=NO, 1=YES)", 
    xlab = "Feeling of Responsibility")
```

![plot of chunk plot_complainXresponsible](figure/plot_complainXresponsible2.png) 


Based on these plots, it looks like participants who felt more responsible about missing a plane or a train considered complaining less than participants
who felt less responsible for missing a plane/train. Let's test this hypothesis formally.


Hypothesis Testing
-----------------

Here we will examine how a participant's feeling of *responsibility* influences their tendency to *complain*. Since `complain` is a binary coded variable (i.e., with values of 0 or 1), `complain` is categorical rather than continuous. Thus, we are faced with a **classification** problem, rather than a **linear regression** problem. That is, given a person with some value of `Responsible`, we want to predict whether or not that person is likely to complain; in other words, we want to *classify* that person as "complainer"" (`complain` = 1), or a non-complainer (`complain` = 0). **Logistic regression** can be used to solve a classification problem like this. 


### What if we were to model the data with linear regression?

Here, we've plotted the data, and the linear regression line-of-best-fit:

```r
plot(jitter(d0$complain, factor = 0.5) ~ d0$Responsible, ylab = "P(Complain = 1)", 
    xlab = "Feeling of Responsibility", xlim = c(0, 30))

abline(lm(d0$complain ~ d0$Responsible), col = "red")
```

![plot of chunk plot_linear](figure/plot_linear.png) 


**A few things to note:**

1. The line-of-best-fit tells us the **predicted probability** of complaining (i.e., P(`complain` = 1)) for each level of `Responsible`. For example, someone with a responsible level of "10" would have a 50% probability of complaining; someone with a responsible level of "5" would have a 70% probability of complaining.

2. For greater levels of `Responsible`, the model from linear regression predicts that the probability of complaining would be *less than* 0. This is impossible!


### Sigmoid (logistic) function
Since a straight line won't fit our data well, we instead will use an S-shaped, **sigmoid** function. This function ensures that our output `y` values will fall between 0 and 1, for any value of `x`.

The sigmoid (or "logistic") function is given by the equation:  
_______
<div class=largefont> $P(y=1) = \frac{1}{1+e^{-(b + mx)}}$ </div>
_______

That is, the probability of a person complaining (`complain` = 1) is a function of x, *e* (the base of the natural logarithm, ~ 2.718), and the coefficients from the generalized linear model (*b* = intercept, *m* = coefficient for `Responsible`).

Here's an example of the sigmoid function plotted:

```r
x <- c(-10:10)
b = 0  # intercept
m = 1  # slope
y <- 1/(1 + exp(-(b + m * x)))
plot(x, y, xlab = "X", ylab = "P(Y=1)")
```

![plot of chunk plot_sigmoid](figure/plot_sigmoid.png) 


In general, changing the **intercept** (`b`) shifts the sigmoid along the x-axis; positive intercepts result in a sigmoid to the *right* of x=0, and negative intercepts result in a sigmoid to the *left* of x=0. Changing the **slope** (`m`) changes both the *direction* and the *steepness* of the function. That is, positive slopes result in an "s"-shaped curve, and negative slopes result in a "z"-shaped curve. In addition, larger absolute values of slope result in a steeper function, and smaller absolute values result in a more gradual slope.

If you want to explore how varying the slope and intercept change the shape of the sigmoid function, try changing the coefficients in the .Rmd file, or check out the app [here](http://spark.rstudio.com/supsych/logistic_regression/)).


### Running a general linear model w/ glm()
To estimate the intercept and slope coefficients, we can run a **generalized linear model** using the R function `glm()`. 


```r
rs1 = glm(complain ~ Responsible, data = d0, family = binomial, na.action = na.omit)
summary(rs1)
```

```
## 
## Call:
## glm(formula = complain ~ Responsible, family = binomial, data = d0, 
##     na.action = na.omit)
## 
## Deviance Residuals: 
##    Min      1Q  Median      3Q     Max  
## -1.775  -0.915  -0.673   0.898   1.786  
## 
## Coefficients:
##             Estimate Std. Error z value Pr(>|z|)   
## (Intercept)   1.4866     0.5917    2.51    0.012 * 
## Responsible  -0.1428     0.0462   -3.09    0.002 **
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## (Dispersion parameter for binomial family taken to be 1)
## 
##     Null deviance: 87.194  on 62  degrees of freedom
## Residual deviance: 76.013  on 61  degrees of freedom
## AIC: 80.01
## 
## Number of Fisher Scoring iterations: 4
```

```r

# coeffeci
rs1$coefficients
```

```
## (Intercept) Responsible 
##      1.4866     -0.1428
```



Now, let's take the coefficients from the model, and put them into our sigmoid function to generate predicted values:

```r
# plot the data
plot(jitter(d0$complain, factor = 0.5) ~ d0$Responsible, ylab = "P(Complain = 1)", 
    xlab = "Feeling of Responsibility", ylim = c(0, 1), xlim = c(0, 20))

# plot the predicted values using the sigmoid function
x <- c(0:20)
b = rs1$coefficients[1]  # intercept
m = rs1$coefficients[2]  # slope
y <- 1/(1 + exp(-(b + m * x)))

par(new = TRUE)  # don't erase what's already on the plot!
plot(x, y, xlab = "", ylab = "", pch = 16, ylim = c(0, 1), xlim = c(0, 20), 
    col = "red")
```

![plot of chunk plot_logistic](figure/plot_logistic.png) 


Since the slope (m = -0.1428; i.e., the coefficient for `Responsible`) is negative, the function is flipped from the s-shaped sigmoid shown above. Further, since the slope is small, the drop-off in the function is more gradual.

### Interpreting the output from glm()


