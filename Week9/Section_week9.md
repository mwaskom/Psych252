Section Week 9 - Mixed Modeling continued 
========================================================

## Nested Models

### Question 2

Today we'll be looking at an edited version of the file `skv-ex4.r`. This version stresses which features of the data are modeled as fixed or random effects by plotting the data using ggplot, going through a simple model bulding exercise and reviewing pitfalls in overfitting random effects.  

Let's take a moment to review the study we're examining, from the *Notes* in the homework. 

In ‘ex4.txt’, each subject completes a 2 x 3 (Task *(free or cued)* x Valence *(positive, negative, or neutral)*) design; so this is an Subject x Task x Valence design with n = 1 observations per cell. 

<img src="http://www.stanford.edu/~lchowe/study_design.png">

*Note: You can insert images into your .Rmd file by using the following syntax:*


```r
# <img src='http://www.stanford.edu/~lchowe/study_design.png'>
```


In this design, we have **nested variables**

Tasks are nested within Subjects, Valence is nested within Tasks (and Subjects).

<img src="http://www.stanford.edu/~lchowe/nested.png">

Note that nested models don’t necessarily have to have random effects.

Example:

`lm(Recall ~ Task)`

`lm(Recall ~ Task + Valence)` $\leftarrow$ *`lm(Recall ~ Task)` is nested within this model*

`lm(Recall ~ Task * Valence)` $\leftarrow$ *`lm(Recall ~ Task + Valence)` is nested within this model*

With the interactive model, R is testing `lm(Recall ~ Task + Valence + Task.Valence)` 
wherein `Task.Valence` is the product of Task and Valence

Let's practice identifying whether models are nested. *Note that it's important to be able to answer these questions during model comparison, as we'll see below!*

<img src="http://www.stanford.edu/~lchowe/arenested.png">

Now let's practice identifying whether models have the same fixed effects structure.

<img src="http://www.stanford.edu/~lchowe/samefixed.png">

## Overparameterization

In this study, we can estimate main and 2-way interaction effects, but there are no degrees of freedom left to estimate the Subject x Task x Valence interaction separately from ‘error’ variance. Put otherwise, in non-overparameterized models the degrees of freedom are greater than zero.

Any model that tries to estimate this 3-way interaction from these data is **over-parameterized**.  An over-parameterized model is one in which there are as many estimated parameters as data points. An overparamterized model is a model that is overparameterized to the point that it is basically just drawing lines between the data. This basically means that this model is useless, because it does not describe the data more parsimoniously than the raw data does (and describing data parsimoniously is generally the idea behind using a model). 

Take for example the mean as a model for some data. If you have only one data point (e.g., 5) using the mean (i.e., 5; note that the mean is an overparameterized model for only one data point) does not help at all. However if you already have two data points (e.g., 5 and 7) using the mean (i.e., 6) as a model provides you with a more parsimonious description than the original data.

If you're trying to build a predictive model this is very problematic. An overparameterized model will lead to a perfect fit, but will be of little use statistically, as you have no data left to estimate variance. Overparameterized models lead to extremely high-variance predictors that are being pushed around by the noise more than the actual data.

When models are over-parameterized, the results of the model fit should include some symptom of the unreliability of the results (e.g., an ‘error’ message that the model-fitting algorithm did not converge; or, if there is no error message, some clue that the parameter estimates are not the optimal, maximum likelihood estimates and, therefore, are not to be trusted). 

### Choosing random effects to avoid overparameterization

The risk of overparameterization limits the choice of random effects that can be estimated from these data. Below, we'll see that allowable (not necessarily justifiable!) specifications are *a random intercept for each subject:* (1 | S), *a random slope for task by subject:* (1 + T | S), and *random slopes for task and valence by subject:* (1 + T + V | S); but *allowing the interaction between task and valence to vary by subject:* (1 + T * V | S) is not, because this would imply that the Task x Valence interaction varies across subjects, i.e., that there is an Subject x Task x Valence interaction.

In the present example, we'll see that one symptom of the unreliability of the results is the correlation of -1 between the slope for ‘taskfree’ and the random intercept. Another symptom is that the results change when the order of Task and Valence is reversed in the model specification – the deviance and some parameter estimates change.

Let's go ahead and load in our data, and get our libraries set up!


```r
library(lme4)
```

```
## Loading required package: lattice Loading required package: Matrix
```

```r
library(ggplot2)
```

```
## Attaching package: 'ggplot2'
## 
## The following object is masked from 'package:lme4':
## 
## fortify
```

```r

setwd("~/Dropbox/TA/Psych252_MW/WWW/datasets")
d0 <- read.table("ex4.txt", header = TRUE)
head(d0)
```

```
##   Observation Subject Task Valence Recall
## 1           1     Jim Free     Neg      8
## 2           2     Jim Free     Neu      9
## 3           3     Jim Free     Pos      5
## 4           4     Jim Cued     Neg      7
## 5           5     Jim Cued     Neu      9
## 6           6     Jim Cued     Pos     10
```



Note that our data is in long form so we know that we can use `lmer()` with the data. If the data were in short form, what would it look like?

<img src="http://www.stanford.edu/~lchowe/shortform.png">

As always, a good approach is to plot the data in a format that provides the information we are looking for. We now know that this can be efficiently done with ggplot when we need to visualize random effects. Which variables would we want to consider as random effects here?


```r
p <- ggplot(d0, aes(x = Valence, y = Recall, group = Task, colour = Task))
p + geom_point() + facet_wrap(~Subject, ncol = 5, scales = "fixed") + geom_smooth(method = "lm", 
    se = FALSE)
```

![plot of chunk unnamed-chunk-3](figure/unnamed-chunk-3.png) 


The plot above gives us gives us a good idea about the results we might expect to be significant. What can we say about this data?

Before discussing the bulk of the script given, which illustrates some sophisticated considerations about overfitting random effects, we should first try to test our own impressions about the data. 

We know that the model

`lm(Recall ~ Task * Valence)` doesn't take into account within-subjects variance or the structure of our experiment so we wouldn't use that.

A simple model with random intercept only, and task as fixed effects, can capture the consistent feature of the plots with the mean of cued recall being higher than the mean of free recall. 

This model looks at the effect of task on recall controlling for overall between subjects variance (differences in means between each subject). Subjects differ overall in how much they recall regardless of task. When we hold this variation constant, we can then pull out the pattern that is shared between subjects.

<img src="http://www.stanford.edu/~lchowe/1sub.png">


```r
rs.lmer0 = lmer(Recall ~ Task + (1 | Subject), d0)
summary(rs.lmer0)
```

```
## Linear mixed model fit by REML ['lmerMod']
## Formula: Recall ~ Task + (1 | Subject) 
##    Data: d0 
## 
## REML criterion at convergence: 129.7 
## 
## Random effects:
##  Groups   Name        Variance Std.Dev.
##  Subject  (Intercept) 14.04    3.75    
##  Residual              3.07    1.75    
## Number of obs: 30, groups: Subject, 5
## 
## Fixed effects:
##             Estimate Std. Error t value
## (Intercept)    12.80       1.74    7.38
## TaskFree       -2.00       0.64   -3.13
## 
## Correlation of Fixed Effects:
##          (Intr)
## TaskFree -0.184
```


This model gives us something close to a paired-t.test on "Task." 


```r
with(d0, t.test(Recall[Task == "Cued"], Recall[Task == "Free"], paired = TRUE))
```

```
## 
## 	Paired t-test
## 
## data:  Recall[Task == "Cued"] and Recall[Task == "Free"]
## t = 3.369, df = 14, p-value = 0.004586
## alternative hypothesis: true difference in means is not equal to 0
## 95 percent confidence interval:
##  0.7268 3.2732
## sample estimates:
## mean of the differences 
##                       2
```


Another possible model:


```r
rs.lmer0 = lmer(Recall ~ Task + (Task | Subject), d0)
summary(rs.lmer0)
```

```
## Linear mixed model fit by REML ['lmerMod']
## Formula: Recall ~ Task + (Task | Subject) 
##    Data: d0 
## 
## REML criterion at convergence: 126 
## 
## Random effects:
##  Groups   Name        Variance Std.Dev. Corr 
##  Subject  (Intercept) 19.57    4.42          
##           TaskFree     1.78    1.33     -1.00
##  Residual              2.62    1.62          
## Number of obs: 30, groups: Subject, 5
## 
## Fixed effects:
##             Estimate Std. Error t value
## (Intercept)    12.80       2.02    6.33
## TaskFree       -2.00       0.84   -2.38
## 
## Correlation of Fixed Effects:
##          (Intr)
## TaskFree -0.798
```


This looks at the effect of task on recall controlling for between subjects variance. Subjects may vary on how well they recall on the task. For some subjects, the difference might be greater between the type of task; for some, the difference is less. Controlling for this variation allows us to pull out if there is a difference at all between the tasks while controlling for this variation (how much difference there may be that differs by subject). In other words: do the slopes of task differ?

<img src="http://www.stanford.edu/~lchowe/tasksub.png">

Similarly, we could also expect that valence might affect our participants differently. So we could include a random effects term for valence, `(Valence | Subject)`, to see if the slopes differ by participant.

<img src="http://www.stanford.edu/~lchowe/valsub.png">

Now, let's add valence in to the mix in our models.

Let's treat valence as a 3-level factor dummy coded to see if there are differences by valence types.


```r
d0$Valencefac <- factor(d0$Valence, levels = c("Neu", "Neg", "Pos"))
rs.lmer01 = lmer(Recall ~ Task + Valencefac + (1 | Subject), d0)
summary(rs.lmer01)
```

```
## Linear mixed model fit by REML ['lmerMod']
## Formula: Recall ~ Task + Valencefac + (1 | Subject) 
##    Data: d0 
## 
## REML criterion at convergence: 124 
## 
## Random effects:
##  Groups   Name        Variance Std.Dev.
##  Subject  (Intercept) 14.1     3.75    
##  Residual              2.9     1.70    
## Number of obs: 30, groups: Subject, 5
## 
## Fixed effects:
##               Estimate Std. Error t value
## (Intercept)     13.100      1.789    7.32
## TaskFree        -2.000      0.622   -3.21
## ValencefacNeg   -1.100      0.762   -1.44
## ValencefacPos    0.200      0.762    0.26
## 
## Correlation of Fixed Effects:
##             (Intr) TaskFr VlncfN
## TaskFree    -0.174              
## ValencefcNg -0.213  0.000       
## ValencefcPs -0.213  0.000  0.500
```


Neither positive nor negative valence are different from neutral.

We could also try Valence as a 3-level factor coded for linear contrast, this assumes that there is a continuum of valence and that we go from negative on one end to positive in the other. 


```r
d0$Valencefac2 <- factor(d0$Valence, levels = c("Neu", "Neg", "Pos"))
contrasts(d0$Valencefac2, 1) = c(-1, 0, 1)
rs.lmer02 = lmer(Recall ~ Task + Valencefac2 + (1 | Subject), d0)
summary(rs.lmer02)
```

```
## Linear mixed model fit by REML ['lmerMod']
## Formula: Recall ~ Task + Valencefac2 + (1 | Subject) 
##    Data: d0 
## 
## REML criterion at convergence: 129.6 
## 
## Random effects:
##  Groups   Name        Variance Std.Dev.
##  Subject  (Intercept) 14.01    3.74    
##  Residual              3.19    1.79    
## Number of obs: 30, groups: Subject, 5
## 
## Fixed effects:
##              Estimate Std. Error t value
## (Intercept)    12.800      1.737    7.37
## TaskFree       -2.000      0.653   -3.06
## Valencefac21    0.100      0.400    0.25
## 
## Correlation of Fixed Effects:
##             (Intr) TaskFr
## TaskFree    -0.188       
## Valencefc21  0.000  0.000
```


Still, in this model valence is not predicting recall. 

We should ask ourselves if we are doing any better by including valence in the model. So let's test nested models and see. 

First, we need to set our models to REML = FALSE! Why?

*Point out model comparison on Coursework*

<img src="http://www.stanford.edu/class/psych252/tutorials/model_comparisons.png">


```r
rs.lmer0a = lmer(Recall ~ Task + (1 | Subject), d0, REML = FALSE)
rs.lmer01a = lmer(Recall ~ Task + Valencefac + (1 | Subject), d0, REML = FALSE)
rs.lmer02a = lmer(Recall ~ Task + Valencefac2 + (1 | Subject), d0, REML = FALSE)
```


Now let's compare our models!


```r
anova(rs.lmer0a, rs.lmer01a)
```

```
## Data: d0
## Models:
## rs.lmer0a: Recall ~ Task + (1 | Subject)
## rs.lmer01a: Recall ~ Task + Valencefac + (1 | Subject)
##            Df AIC BIC logLik deviance Chisq Chi Df Pr(>Chisq)
## rs.lmer0a   4 141 147  -66.7      133                        
## rs.lmer01a  6 142 150  -64.9      130  3.57      2       0.17
```

```r
anova(rs.lmer0a, rs.lmer02a)
```

```
## Data: d0
## Models:
## rs.lmer0a: Recall ~ Task + (1 | Subject)
## rs.lmer02a: Recall ~ Task + Valencefac2 + (1 | Subject)
##            Df AIC BIC logLik deviance Chisq Chi Df Pr(>Chisq)
## rs.lmer0a   4 141 147  -66.7      133                        
## rs.lmer02a  5 143 150  -66.7      133  0.07      1       0.79
```


*Why are these models nested?* 

From this, we can see that our model with the fixed effects of task and valence, and a random intercept for each subject does not seem to be performing any better than the model with the random slope for task (allowed to vary by participant) along with the fixed effects. The model with valence coded as a linear contrast doesn't perform any better either.

We may wonder if we should continue pursuing either of the more complex models by considering more of the random effects present. Before doing that it would be useful to know if the added degrees of freedom in the dummy coded model buy us real explanatory power. 

As we are told in the handout, it is not appropriate to treat rs.lmer01 and rs.lmer02 as nested. Also they differ in their fixed effects. So simply running an ANOVA and comparing the models on REML is not a good idea. The aproach we can follow to deal with this comparison is to re-estimate the models using ML. 


```r
summary(rs.lmer01)
```

```
## Linear mixed model fit by REML ['lmerMod']
## Formula: Recall ~ Task + Valencefac + (1 | Subject) 
##    Data: d0 
## 
## REML criterion at convergence: 124 
## 
## Random effects:
##  Groups   Name        Variance Std.Dev.
##  Subject  (Intercept) 14.1     3.75    
##  Residual              2.9     1.70    
## Number of obs: 30, groups: Subject, 5
## 
## Fixed effects:
##               Estimate Std. Error t value
## (Intercept)     13.100      1.789    7.32
## TaskFree        -2.000      0.622   -3.21
## ValencefacNeg   -1.100      0.762   -1.44
## ValencefacPos    0.200      0.762    0.26
## 
## Correlation of Fixed Effects:
##             (Intr) TaskFr VlncfN
## TaskFree    -0.174              
## ValencefcNg -0.213  0.000       
## ValencefcPs -0.213  0.000  0.500
```

```r
summary(rs.lmer01a)
```

```
## Linear mixed model fit by maximum likelihood ['lmerMod']
## Formula: Recall ~ Task + Valencefac + (1 | Subject) 
##    Data: d0 
## 
##      AIC      BIC   logLik deviance 
##   141.81   150.22   -64.91   129.81 
## 
## Random effects:
##  Groups   Name        Variance Std.Dev.
##  Subject  (Intercept) 11.21    3.35    
##  Residual              2.55    1.60    
## Number of obs: 30, groups: Subject, 5
## 
## Fixed effects:
##               Estimate Std. Error t value
## (Intercept)     13.100      1.607    8.15
## TaskFree        -2.000      0.584   -3.43
## ValencefacNeg   -1.100      0.715   -1.54
## ValencefacPos    0.200      0.715    0.28
## 
## Correlation of Fixed Effects:
##             (Intr) TaskFr VlncfN
## TaskFree    -0.182              
## ValencefcNg -0.222  0.000       
## ValencefcPs -0.222  0.000  0.500
```


Note that the models are clearly different in terms of random effects coefficients and summary results, e.g. logLik


```r
summary(rs.lmer02)
```

```
## Linear mixed model fit by REML ['lmerMod']
## Formula: Recall ~ Task + Valencefac2 + (1 | Subject) 
##    Data: d0 
## 
## REML criterion at convergence: 129.6 
## 
## Random effects:
##  Groups   Name        Variance Std.Dev.
##  Subject  (Intercept) 14.01    3.74    
##  Residual              3.19    1.79    
## Number of obs: 30, groups: Subject, 5
## 
## Fixed effects:
##              Estimate Std. Error t value
## (Intercept)    12.800      1.737    7.37
## TaskFree       -2.000      0.653   -3.06
## Valencefac21    0.100      0.400    0.25
## 
## Correlation of Fixed Effects:
##             (Intr) TaskFr
## TaskFree    -0.188       
## Valencefc21  0.000  0.000
```

```r
summary(rs.lmer02a)
```

```
## Linear mixed model fit by maximum likelihood ['lmerMod']
## Formula: Recall ~ Task + Valencefac2 + (1 | Subject) 
##    Data: d0 
## 
##      AIC      BIC   logLik deviance 
##   143.32   150.32   -66.66   133.32 
## 
## Random effects:
##  Groups   Name        Variance Std.Dev.
##  Subject  (Intercept) 11.15    3.34    
##  Residual              2.94    1.71    
## Number of obs: 30, groups: Subject, 5
## 
## Fixed effects:
##              Estimate Std. Error t value
## (Intercept)    12.800      1.557    8.22
## TaskFree       -2.000      0.626   -3.20
## Valencefac21    0.100      0.383    0.26
## 
## Correlation of Fixed Effects:
##             (Intr) TaskFr
## TaskFree    -0.201       
## Valencefc21  0.000  0.000
```


Ditto here.

We can now compare them asuming the difference between deviances is distributed as a chi-square with df= differences in df of each model. 


```r
1 - pchisq(-2 * logLik(rs.lmer02a)[1] - -2 * logLik(rs.lmer01a)[1], 1)
```

```
## [1] 0.06134
```


As suggested in the handout, the model using more degrees of freedom (3-level dummy coded) provides a better fit and in this case it is marginally better than the linear contrast coded. Let's pursue it by changing its random effects and seeing of we can improve on it.

First we can add a "slope" term to account for the fact that valence has different effects on every subject. *Is this really a "slope"?*


```r
rs.lmer1 = lmer(Recall ~ Task + Valencefac + (1 + Valencefac | Subject), d0)
summary(rs.lmer1)
```

```
## Linear mixed model fit by REML ['lmerMod']
## Formula: Recall ~ Task + Valencefac + (1 + Valencefac | Subject) 
##    Data: d0 
## 
## REML criterion at convergence: 121.6 
## 
## Random effects:
##  Groups   Name          Variance Std.Dev. Corr       
##  Subject  (Intercept)   11.47    3.39                
##           ValencefacNeg  1.19    1.09      0.81      
##           ValencefacPos  1.15    1.07      0.23 -0.39
##  Residual                2.22    1.49                
## Number of obs: 30, groups: Subject, 5
## 
## Fixed effects:
##               Estimate Std. Error t value
## (Intercept)     13.100      1.610    8.14
## TaskFree        -2.000      0.544   -3.67
## ValencefacNeg   -1.100      0.826   -1.33
## ValencefacPos    0.200      0.822    0.24
## 
## Correlation of Fixed Effects:
##             (Intr) TaskFr VlncfN
## TaskFree    -0.169              
## ValencefcNg  0.284  0.000       
## ValencefcPs -0.044  0.000  0.194
```


Did we improve? Note that we now use REML, because we have the same fixed-effects.


```r
anova(rs.lmer01, rs.lmer1)
```

```
## Data: d0
## Models:
## rs.lmer01: Recall ~ Task + Valencefac + (1 | Subject)
## rs.lmer1: Recall ~ Task + Valencefac + (1 + Valencefac | Subject)
##           Df AIC BIC logLik deviance Chisq Chi Df Pr(>Chisq)
## rs.lmer01  6 142 150  -64.9      130                        
## rs.lmer1  11 149 165  -63.7      127  2.43      5       0.79
```


It seems we haven't done any better. 

Alternatively, we could  take note of the fact that the effect of task is larger in some subjects than others and add a "slope" term for task?


```r
rs.lmer1a = lmer(Recall ~ Task + Valencefac + (1 + Task | Subject), d0)
summary(rs.lmer1a)
```

```
## Linear mixed model fit by REML ['lmerMod']
## Formula: Recall ~ Task + Valencefac + (1 + Task | Subject) 
##    Data: d0 
## 
## REML criterion at convergence: 120.1 
## 
## Random effects:
##  Groups   Name        Variance Std.Dev. Corr 
##  Subject  (Intercept) 19.62    4.43          
##           TaskFree     1.78    1.34     -1.00
##  Residual              2.41    1.55          
## Number of obs: 30, groups: Subject, 5
## 
## Fixed effects:
##               Estimate Std. Error t value
## (Intercept)     13.100      2.060    6.36
## TaskFree        -2.000      0.824   -2.43
## ValencefacNeg   -1.100      0.694   -1.58
## ValencefacPos    0.200      0.694    0.29
## 
## Correlation of Fixed Effects:
##             (Intr) TaskFr VlncfN
## TaskFree    -0.792              
## ValencefcNg -0.168  0.000       
## ValencefcPs -0.168  0.000  0.500
```

```r

anova(rs.lmer01, rs.lmer1a)
```

```
## Data: d0
## Models:
## rs.lmer01: Recall ~ Task + Valencefac + (1 | Subject)
## rs.lmer1a: Recall ~ Task + Valencefac + (1 + Task | Subject)
##           Df AIC BIC logLik deviance Chisq Chi Df Pr(>Chisq)
## rs.lmer01  6 142 150  -64.9      130                        
## rs.lmer1a  8 141 152  -62.7      125  4.49      2       0.11
```


But again we don't seem to be doing much better. At this point it would be wise to stop, but an overly ambitious approach might compell us to keep playing with the random effect terms to try and squeeze an effect for valence. This aproach has several potential perils. 

Let's try to use two slope terms (1 + T + V | Subject) 


```r
rs.lmer2 = lmer(Recall ~ Task + Valencefac + (1 + Valencefac + Task | Subject), 
    d0)
summary(rs.lmer2)
```

```
## Linear mixed model fit by REML ['lmerMod']
## Formula: Recall ~ Task + Valencefac + (1 + Valencefac + Task | Subject) 
##    Data: d0 
## 
## REML criterion at convergence: 116.8 
## 
## Random effects:
##  Groups   Name          Variance Std.Dev. Corr             
##  Subject  (Intercept)   16.431   4.054                     
##           ValencefacNeg  0.822   0.907     1.00            
##           ValencefacPos  2.196   1.482     0.11  0.11      
##           TaskFree       1.800   1.342    -0.97 -0.97 -0.35
##  Residual                1.723   1.313                     
## Number of obs: 30, groups: Subject, 5
## 
## Fixed effects:
##               Estimate Std. Error t value
## (Intercept)     13.100      1.875    6.99
## TaskFree        -2.000      0.768   -2.60
## ValencefacNeg   -1.100      0.714   -1.54
## ValencefacPos    0.200      0.885    0.23
## 
## Correlation of Fixed Effects:
##             (Intr) TaskFr VlncfN
## TaskFree    -0.814              
## ValencefcNg  0.421 -0.431       
## ValencefcPs -0.021 -0.203  0.321
```

```r
anova(rs.lmer01, rs.lmer2)
```

```
## Data: d0
## Models:
## rs.lmer01: Recall ~ Task + Valencefac + (1 | Subject)
## rs.lmer2: Recall ~ Task + Valencefac + (1 + Valencefac + Task | Subject)
##           Df AIC BIC logLik deviance Chisq Chi Df Pr(>Chisq)
## rs.lmer01  6 142 150  -64.9      130                        
## rs.lmer2  15 151 172  -60.5      121   8.9      9       0.45
```


Again the increased complexity in random effects is not justified and we have similar conclusions as before. But notice that the correlation between the task free and coefficient terms in the random effects is close to 1, i.e. -.97. These kinds of correlations can be a symptom of a problematic fit. For example, note what happens when we switch the order of the tems in the random effects.


```r
rs.lmer2a = lmer(Recall ~ Task + Valencefac + (1 + Task + Valencefac | Subject), 
    d0)
summary(rs.lmer2a)
```

```
## Linear mixed model fit by REML ['lmerMod']
## Formula: Recall ~ Task + Valencefac + (1 + Task + Valencefac | Subject) 
##    Data: d0 
## 
## REML criterion at convergence: 115.7 
## 
## Random effects:
##  Groups   Name          Variance Std.Dev. Corr             
##  Subject  (Intercept)   16.69    4.09                      
##           TaskFree       1.99    1.41     -0.96            
##           ValencefacNeg  1.43    1.20      0.68 -0.46      
##           ValencefacPos  1.34    1.16      0.24 -0.43 -0.43
##  Residual                1.54    1.24                      
## Number of obs: 30, groups: Subject, 5
## 
## Fixed effects:
##               Estimate Std. Error t value
## (Intercept)     13.100      1.882    6.96
## TaskFree        -2.000      0.777   -2.57
## ValencefacNeg   -1.100      0.770   -1.43
## ValencefacPos    0.200      0.759    0.26
## 
## Correlation of Fixed Effects:
##             (Intr) TaskFr VlncfN
## TaskFree    -0.829              
## ValencefcNg  0.354 -0.259       
## ValencefcPs  0.052 -0.236  0.058
```


Now several parameter estimates have changed and we see a correlation of -.96 between "taskfree" and the random intercept. 

In the HW handout we are given an explanation for why undesirable results like this one occur, which has to do with over-fitting the data.

As an extreme example we are given the following model, which even gives an warning message of false convergence!


```r
contrasts(d0$Valence) = contr.treatment(3, base = 2)
rs.lmer3a = lmer(Recall ~ Task + Valence + (1 + Valence * Task | Subject), d0)  # Note the warning error message. 
```

```
## Warning: number of observations <= rank(Z); variance-covariance matrix
## will be unidentifiable Warning: failure to converge in 10000 evaluations
```

```r
summary(rs.lmer3a)
```

```
## Linear mixed model fit by REML ['lmerMod']
## Formula: Recall ~ Task + Valence + (1 + Valence * Task | Subject) 
##    Data: d0 
## 
## REML criterion at convergence: 105.4 
## 
## Random effects:
##  Groups   Name              Variance Std.Dev. Corr                   
##  Subject  (Intercept)       9.495    3.081                           
##           Valence1          5.556    2.357     0.60                  
##           Valence3          0.465    0.682     0.16 -0.69            
##           TaskFree          1.298    1.139    -0.52  0.34 -0.92      
##           Valence1:TaskFree 6.196    2.489    -0.69 -0.88  0.49 -0.18
##           Valence3:TaskFree 3.194    1.787     0.14  0.02  0.13 -0.18
##  Residual                   0.465    0.682                           
##       
##       
##       
##       
##       
##       
##  -0.12
##       
## Number of obs: 30, groups: Subject, 5
## 
## Fixed effects:
##             Estimate Std. Error t value
## (Intercept)   13.359      1.148   11.64
## TaskFree      -1.962      0.577   -3.40
## Valence1      -1.067      0.619   -1.72
## Valence3       0.463      0.501    0.93
## 
## Correlation of Fixed Effects:
##          (Intr) TaskFr Valnc1
## TaskFree -0.849              
## Valence1  0.075  0.153       
## Valence3  0.113 -0.259 -0.246
```


To drive the point home that the problem has to do with over fitting or exhausting our degrees of freedom, rather than modeling complex random effects per-se, we are given another dataset in which we have two observations at each task-valence level. This dataset does not suffer from the same problems in changing parameter estimates because we have more degrees of freedom within subjects and lmer can reliably estimate the required parameters, even in very complex models.

From the HW: `In ‘ex4L.txt’, each S completes a 2 x 3 (Task x Valence) design twice; so this is a Subject x Task x Valence design with n > 1 obs per cell. We now have enough df to estimate the SxTxV interaction separately from ‘error’ variance, and (1+T*V|S) would be an allowable specification of the random effects. Students might want to check that the results of testing this most complex model on this larger data set seem to be acceptable.`

To close out this example, let's practice deciding how we would compare models.

<img src="http://www.stanford.edu/~lchowe/nestedprac1.png">
<img src="http://www.stanford.edu/~lchowe/nestedprac2.png">
<img src="http://www.stanford.edu/~lchowe/nestedprac3.png">
<img src="http://www.stanford.edu/~lchowe/nestedprac4.png">

## Question 4

To investigate whether the saying “Time flies when you’re having fun,” an experiment was conducted in which participants heard sound clips from 20 podcasts ranging from 30 to 90 seconds. Ten of the podcasts were taken from comedy routines, while ten were taken from a tedious statistics class.

There were two dependent measures collected:
- Subjects reported how fun the clip was to listen to (on a scale from 0, not fun at all, to 7, hilariously awesome)
- Subjects estimated how long (in seconds) the clip lasted.


```r
setwd("~/Dropbox/TA/Psych252_MW/WWW/datasets")
d <- read.csv("timeflies.csv")
library(reshape2)
```


**IMPORTANT STEP SO THAT YOU CAN USE THE CODE IN THE HW PDF:**
This takes out the first column, which just lists subject id numbers.


```r
timeflies = d[, -1]
```


See how data is stored, with each row being one subject:

```r
head(timeflies)
```

```
##   comclip1.rat comclip2.rat comclip3.rat comclip4.rat comclip5.rat
## 1            4            4            1            2            5
## 2            4            2            2            4            4
## 3            2            5            4            2            4
## 4            4            4            5            5            2
## 5            2            3            5            5            4
## 6            2            4            3            5            5
##   comclip6.rat comclip7.rat comclip8.rat comclip9.rat comclip10.rat
## 1            3            3            5            5             3
## 2            3            4            4            3             3
## 3            1            3            3            1             4
## 4            3            4            4            3             3
## 5            5            5            5            4             3
## 6            4            2            3            2             3
##   statsclip1.rat statsclip2.rat statsclip3.rat statsclip4.rat
## 1              0              4              3              2
## 2              2              3              3              2
## 3              2              3              2              3
## 4              2              4              4              3
## 5              3              4              4              4
## 6              2              4              5              3
##   statsclip5.rat statsclip6.rat statsclip7.rat statsclip8.rat
## 1              3              2              2              4
## 2              5              2              2              3
## 3              3              4              4              3
## 4              1              3              4              4
## 5              3              3              4              4
## 6              2              3              1              1
##   statsclip9.rat statsclip10.rat comclip1.len comclip2.len comclip3.len
## 1              3               3           70           64           99
## 2              2               2           63           79          101
## 3              2               4           94           64           71
## 4              1               3           63           80           50
## 5              4               3           85           57           47
## 6              3               3           84           66           68
##   comclip4.len comclip5.len comclip6.len comclip7.len comclip8.len
## 1           83           69           72           78           62
## 2           79           82           82           64           70
## 3           69           74           83           68           91
## 4           62           91           88           75           62
## 5           53           68           75           49           55
## 6           62           55           64           87           87
##   comclip9.len comclip10.len statsclip1.len statsclip2.len statsclip3.len
## 1           47            68            114             65             72
## 2           84            69             95             74             77
## 3          104            69             86             76             92
## 4           82            72             92             62             56
## 5           62            80             82             78             69
## 6           84            85            100             67             64
##   statsclip4.len statsclip5.len statsclip6.len statsclip7.len
## 1            103             81             72             74
## 2             92             61             82             98
## 3             86             73             70             71
## 4             88             97             74             56
## 5             77             80             86             59
## 6             77             93             93            106
##   statsclip8.len statsclip9.len statsclip10.len
## 1             73             75              97
## 2             72             82              86
## 3             76             83              77
## 4             52            103              54
## 5             74             74              72
## 6             93             70              67
```


The HW states that the researcher was not interested in variability between clips of the same kind.  So, we computed for each subject their average fun rating and their average estimated length for comedy clips and their average fun rating and their average estimated length for statistics clips.


```r
timeflies$comclips.rat <- rowMeans(timeflies[, 1:10])
timeflies$statsclips.rat <- rowMeans(timeflies[, 11:20])
timeflies$comclips.len <- rowMeans(timeflies[, 21:30])
timeflies$statsclips.len <- rowMeans(timeflies[, 31:40])
```


Now let's calculate the difference between comedy and stats clips on each of our dependent variables of interest.


```r
timeflies$diff.rat <- timeflies$comclips.rat - timeflies$statsclips.rat
timeflies$diff.len <- timeflies$comclips.len - timeflies$statsclips.len
```


Sum of fun ratings (because one subject may report everything as funnier than another subject may)


```r
timeflies$csum.rat <- scale(timeflies$comclips.rat + timeflies$statsclips.rat, 
    scale = F)
```


Can you recognize this as a dependent t-test?  Yes!  It is testing our hypothesis that time flies when you're having fun: that is, whether the average estimated length of a comedy clip is significantly less than the estimated length of a statistics clip.


```r
summary(lm(diff.len ~ 1, data = timeflies))
```

```
## 
## Call:
## lm(formula = diff.len ~ 1, data = timeflies)
## 
## Residuals:
##    Min     1Q Median     3Q    Max 
##  -9.95  -4.72  -0.15   4.83   9.05 
## 
## Coefficients:
##             Estimate Std. Error t value Pr(>|t|)   
## (Intercept)   -2.950      0.847   -3.48   0.0012 **
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 5.36 on 39 degrees of freedom
```

```r
t.test(timeflies$diff.len)
```

```
## 
## 	One Sample t-test
## 
## data:  timeflies$diff.len
## t = -3.482, df = 39, p-value = 0.001241
## alternative hypothesis: true mean is not equal to 0
## 95 percent confidence interval:
##  -4.663 -1.237
## sample estimates:
## mean of x 
##     -2.95
```

```r

# Visualized:
ggplot(melt(data.frame(subj = d$X, timeflies[, 43:44]), id.vars = 1), aes(variable, 
    value, group = subj)) + geom_point() + geom_line() + stat_smooth(method = "lm", 
    aes(group = 1), size = 2)
```

![plot of chunk unnamed-chunk-26](figure/unnamed-chunk-26.png) 


We could run another dependent t-test as a manipulation check to see whether subjects rated comedy clips as more fun than the statistics clips.  Unfortunately for the statistics teacher... the manipulation worked.


```r
summary(lm(diff.rat ~ 1, data = timeflies))
```

```
## 
## Call:
## lm(formula = diff.rat ~ 1, data = timeflies)
## 
## Residuals:
##     Min      1Q  Median      3Q     Max 
## -1.0725 -0.3725 -0.0225  0.4275  0.8275 
## 
## Coefficients:
##             Estimate Std. Error t value Pr(>|t|)   
## (Intercept)   0.2725     0.0782    3.48   0.0012 **
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 0.495 on 39 degrees of freedom
```

```r

# Visualized:
ggplot(melt(data.frame(subj = d$X, timeflies[, 41:42]), id.vars = 1), aes(variable, 
    value, group = subj)) + geom_point() + geom_line() + stat_smooth(method = "lm", 
    aes(group = 1), size = 2)
```

![plot of chunk unnamed-chunk-27](figure/unnamed-chunk-27.png) 


To see if this difference in ratings caused the difference in estimated lengths, we could use a linear regression with two predictors: the average difference in a subject’s rating of a comedy clip and their rating of a statistics clip, and the sum of a subject’s average rating of a comedy clip and a statistics clip (which corresponds to how fun they rated the clips in general).


```r
summary(lm(diff.len ~ diff.rat + csum.rat, data = timeflies))
```

```
## 
## Call:
## lm(formula = diff.len ~ diff.rat + csum.rat, data = timeflies)
## 
## Residuals:
##    Min     1Q Median     3Q    Max 
## -6.940 -1.588  0.217  1.669  6.887 
## 
## Coefficients:
##             Estimate Std. Error t value Pr(>|t|)    
## (Intercept)  -0.4543     0.5358   -0.85     0.40    
## diff.rat     -9.1586     0.9841   -9.31  3.1e-11 ***
## csum.rat     -0.0186     1.0360   -0.02     0.99    
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 2.93 on 37 degrees of freedom
## Multiple R-squared:  0.716,	Adjusted R-squared:   0.7 
## F-statistic: 46.5 on 2 and 37 DF,  p-value: 7.91e-11
```


-Effect of diff.rat: For a given subject, the larger the difference in fun rating between a comedy clip and a statistics clip, the larger the difference in estimated length of the clips.
-Intercept: The effect of clip type on perceived length is no longer significant once the difference in fun ratings is included in the model.
-Effect of csum.rat: The fact that someone happens to give high ratings to everything does not give additional information about the difference in perceived length of clips.

This is within-subjects mediation: comedy clips are perceived to be more fun than stats clip, which leads them to be perceived as shorter.


```r
# Visualized:
ggplot(data.frame(subj = d$X, timeflies[, 45:46]), aes(diff.len, diff.rat)) + 
    geom_point() + stat_smooth(method = "lm")
```

![plot of chunk unnamed-chunk-29](figure/unnamed-chunk-29.png) 

