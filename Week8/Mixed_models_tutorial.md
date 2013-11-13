Section Week 8 - Linear Mixed Models
========================================================

How is a linear mixed effects model different from the linear models we know already?

Linear mixed models are a type of regression model that take into account variation that is not explained by the independent variables of interest in your study.

Let's say you're interested in language, and more specifically how voice pitch is related to politeness. You ask your subjects to respond to hypothetical scenarios that are either more formal situations that require politeness (e.g., giving an excuse for being late to a professor) or more informal situations (e.g., explaining to a friend why you're late), and measure their voice pitch. Each subject is given a list of scenarios, so each subject gives multiple polite or informal responses. You also take note of each of your subjects' genders, since you know that's another important influence on voice pitch.

In a linear model as we've seen so far, we would model this as:

`pitch ~ politeness + sex + ε`

Where the last term is our error term. This error term represents the deviations from our predictions due to “random” factors that we cannot control experimentally.

With this kind of data, since each subject gave multiple responses, we can immediately see that this would violate the independence assumption that's important in linear modeling: Multiple responses from the same subject cannot be regarded as independent from each other. Every person has a slightly different voice pitch, and this is going to be an idiosyncratic factor that  affects all responses from the same subject, thus rendering these different responses inter-dependent rather than independent.

## Random Effects

The way we’re going to deal with this situation is to add a random effect for subject. This allows us to resolve this non-independence by assuming a different “baseline” pitch value for each subject. So, subject 1 may have a mean voice pitch of 233 Hz across different utterances, and subject 2 may have a mean voice pitch of 210 Hz. In our model, we account through these individual differences in voice pitch using random effects for subjects.

What would this look like visually? *Refer to graph on Powerpiont.*

Subjects F1 to F9 are female subjects. Subjects M1 to M7 are male subjects. You immediately see that males have lower voices than females (as is to be expected). But on top of that, within the male and the female groups, you see lots of 
individual variation, with some people having relatively higher values for their sex and others having relatively lower values. 
 
We can model these individual differences by assuming different **random intercepts** for each subject. That is, each subject is assigned a different intercept value, and the mixed model estimates these intercepts for you.

Now you begin to see why the mixed model is called a “mixed” model. The linear models that we considered so far have been “fixed-effects-only” models that had one or more fixed effects and a general error term “ε”. With the linear model, we essentially divided the world into things that we somehow understand or that are somehow systematic (the *fixed effects*, or the explanatory variables); and *random error*, things that we cannot control for or that we don’t understand (ε). But crucially, this latter part, the unsystematic part of the model, did not have any interesting structure. We simply had a general across-the-board error term. 

In the mixed model, we add one or more random effects to our fixed effects. These random effects essentially give structure to the error term “ε”. In the case of our model here, we add a random effect for “subject”, and this characterizes idiosyncratic variation that is due to individual differences. 

A *random effect* is generally something that can be expected to have a non-systematic, idiosyncratic, unpredictable, or "random" influence on your data. In experiments, that's often something like your subject or item, and you want to generalize over the idiosyncracies of individual subjects and items.

*Fixed effects*, on the other hand, are expected to have a systematic and predictable influence on your data.
 
The mixture of fixed and random effects is what makes the mixed model a "mixed model."

*What are some examples of fixed and random effects that you might see in mixed modeling?*

- **Fixed effects:** the independent variables that might normally be included in your analyses. For instance: gender, age, your study conditions

- **Random effects:** the variables that are specific to your data sample. For instance: speaker, word, listener, item, scenario

## Random Intercepts

Turning back to our model, our old formula was:

`pitch ~ condition + gender + ε`

Our updated formula looks like this: 

`pitch ~ condition + gender + (1|subject) + ε`

“`(1|subject)`” is the R syntax for a *random intercept*. What this is saying is “assume an intercept that’s different for each subject” … and “1” stands for the intercept here. You can think of this formula as telling your model that it should expect that there’s going to be multiple responses per subject, and these responses will depend on each subject’s baseline level. This effectively resolves the non-independence that stems from having multiple responses by the same subject.

Note that the formula still contains a general error term “ε”. This is necessary because even if we accounted for individual by-subject variation, there’s still going to be “random” differences between different utterances from the same subject.

In the study we've been discussing, there’s an additional source of non-independence beyond subject differences in voice pitch that needs to be accounted for: Let's say we had different items. One item, for example, was an “asking for a favor” scenario. Here, subjects had to imagine asking a professor for a favor (polite condition), or asking a peer for a favor (informal condition). Another item was an “excusing for coming too late” scenario, which was similarly divided between polite and informal. In total, there were 7 such different items. 
 
Similar to the case of by-subject variation, we also expect by-item variation. For example, there might be something special about “excusing for coming too late” which leads to overall higher pitch (maybe because it’s more embarrassing than asking for a favor), regardless of the influence of politeness. And whatever it is that makes one item different from another, the responses of the different subjects in our experiment might similarly be affected by this random factor that is due to item-specific idiosyncrasies. That is, if “excusing for coming to late” leads to high pitch (for whatever reason), it’s going to do so for subject 1, subject 2, subject 3 and so on. Thus, the different responses to one item cannot be regarded as independent, or, in other words, there’s something similar to multiple responses to 
the same item – even if they come from different people. Again, if we did not account for these interdependencies, we would violate the independence assumption. 

We do this by adding an additional random effect: 
 
`pitch ~ condition + gender + (1|subject) + (1|scenario) + ε` 
 
So, on top of *different intercepts for different subjects*, we now also have *different intercepts for different items*. We now “resolved” those non-independencies (our model knows that there are multiple responses per subject and per item), and we accounted for by-subject and by-item variation in overall pitch levels. 

Now let's look at an example with some data borrowed from Winter and Grawunder (2012) - we have a subset of actual data for the study that was described that we get to play around with!

First we need to load in the appropriate packages and dataset:


```r
install.packages("lme4")
```

```
## Error: trying to use CRAN without setting a mirror
```

```r
library(lme4)
```

```
## Loading required package: lattice Loading required package: Matrix
```

```r

d <- read.csv("http://www.bodowinter.com/tutorial/politeness_data.csv")
```


Let's check out our data a little bit!


```r
str(d)
```

```
## 'data.frame':	84 obs. of  5 variables:
##  $ subject  : Factor w/ 6 levels "F1","F2","F3",..: 1 1 1 1 1 1 1 1 1 1 ...
##  $ gender   : Factor w/ 2 levels "F","M": 1 1 1 1 1 1 1 1 1 1 ...
##  $ scenario : int  1 1 2 2 3 3 4 4 5 5 ...
##  $ attitude : Factor w/ 2 levels "inf","pol": 2 1 2 1 2 1 2 1 2 1 ...
##  $ frequency: num  213 204 285 260 204 ...
```

```r
summary(d)
```

```
##  subject gender    scenario attitude   frequency    
##  F1:14   F:42   Min.   :1   inf:42   Min.   : 82.2  
##  F2:14   M:42   1st Qu.:2   pol:42   1st Qu.:131.6  
##  F3:14          Median :4            Median :203.9  
##  M3:14          Mean   :4            Mean   :193.6  
##  M4:14          3rd Qu.:6            3rd Qu.:248.6  
##  M7:14          Max.   :7            Max.   :306.8  
##                                      NA's   :1
```

```r
head(d)
```

```
##   subject gender scenario attitude frequency
## 1      F1      F        1      pol     213.3
## 2      F1      F        1      inf     204.5
## 3      F1      F        2      pol     285.1
## 4      F1      F        2      inf     259.7
## 5      F1      F        3      pol     203.9
## 6      F1      F        3      inf     286.9
```

```r

# Let's rename some things!
names(d)[names(d) == "attitude"] <- "condition"
names(d)[names(d) == "frequency"] <- "pitch"
names(d)
```

```
## [1] "subject"   "gender"    "scenario"  "condition" "pitch"
```

```r

table(d$subject, d$gender)
```

```
##     
##       F  M
##   F1 14  0
##   F2 14  0
##   F3 14  0
##   M3  0 14
##   M4  0 14
##   M7  0 14
```


How can we find missing data and outliers?


```r

# How to find missing values?
which(is.na(d$pitch) == T)
```

```
## [1] 39
```

```r

# How about outliers?
bp <- with(d, boxplot(pitch ~ condition * gender, col = c("white", "lightgray"), 
    condition))
```

![plot of chunk unnamed-chunk-3](figure/unnamed-chunk-3.png) 

```r

bp$out
```

```
## [1] 154.8
```

```r
subset(d, pitch == 154.8)
```

```
##    subject gender scenario condition pitch
## 14      F1      F        7       pol 154.8
```


Let's start exploring some models!


```r
lmer(pitch ~ condition, data = d)  # this doesn't work! Need a random error term to use lmer
```

```
## Error: No random effects terms specified in formula
```

```r

politeness.model = lmer(pitch ~ condition + (1 | subject) + (1 | scenario), 
    data = d)
summary(politeness.model)
```

```
## Linear mixed model fit by REML ['lmerMod']
## Formula: pitch ~ condition + (1 | subject) + (1 | scenario) 
##    Data: d 
## 
## REML criterion at convergence: 793.5 
## 
## Random effects:
##  Groups   Name        Variance Std.Dev.
##  scenario (Intercept)  219     14.8    
##  subject  (Intercept) 4015     63.4    
##  Residual              646     25.4    
## Number of obs: 83, groups: scenario, 7; subject, 6
## 
## Fixed effects:
##              Estimate Std. Error t value
## (Intercept)    202.59      26.75    7.57
## conditionpol   -19.69       5.58   -3.53
## 
## Correlation of Fixed Effects:
##             (Intr)
## conditionpl -0.103
```

```r
coef(politeness.model)
```

```
## $scenario
##   (Intercept) conditionpol
## 1       189.1       -19.69
## 2       209.2       -19.69
## 3       214.0       -19.69
## 4       223.2       -19.69
## 5       200.6       -19.69
## 6       190.5       -19.69
## 7       191.6       -19.69
## 
## $subject
##    (Intercept) conditionpol
## F1       241.4       -19.69
## F2       267.3       -19.69
## F3       259.9       -19.69
## M3       179.1       -19.69
## M4       154.7       -19.69
## M7       113.1       -19.69
## 
## attr(,"class")
## [1] "coef.mer"
```


Let’s focus on the output for the random effects first: 

Have a look at the column standard deviation. This is a measure of the variability for each random effect that you added to the model. You can see that scenario (“item”) has much less variability than subject. Based on our boxplots from above, where we saw more idiosyncratic differences between subjects than between items, this is to be expected. Then, you see “Residual” which stands for the variability that’s not due to either scenario or subject. This is our “ε” again, the “random” deviations from the predicted values that are not due to subjects and items. Here, this reflects the fact that each and every utterance has some factors that affect pitch that are outside the scope of our experiment. 

What would this have looked like if we hadn't used a mixed model?


```r
summary(lm(pitch ~ condition, d))
```

```
## 
## Call:
## lm(formula = pitch ~ condition, data = d)
## 
## Residuals:
##     Min      1Q  Median      3Q     Max 
## -103.49  -62.12    9.04   51.18  105.04 
## 
## Coefficients:
##              Estimate Std. Error t value Pr(>|t|)    
## (Intercept)     202.6       10.1   20.11   <2e-16 ***
## conditionpol    -18.2       14.3   -1.27     0.21    
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 65.3 on 81 degrees of freedom
##   (1 observation deleted due to missingness)
## Multiple R-squared:  0.0196,	Adjusted R-squared:  0.00747 
## F-statistic: 1.62 on 1 and 81 DF,  p-value: 0.207
```


Not only should we not do this because it violates the assumption of independence, but it obscures the pattern that we would otherwise see in our data.

If you look back at the boxplot that we constructed earlier, you can see that the value 202.588 Hz seems to fall halfway between males and females – and this is indeed what this intercept represents. It’s the average of our data for the informal condition.

As we didn’t inform our model that there’s two sexes in our dataset, the intercept is particularly off, in between the voice pitch of males and females.

Let's add gender as a fixed effect:


```r
politeness.model2 = lmer(pitch ~ condition + gender + (1 | subject) + (1 | scenario), 
    data = d)
summary(politeness.model2)
```

```
## Linear mixed model fit by REML ['lmerMod']
## Formula: pitch ~ condition + gender + (1 | subject) + (1 | scenario) 
##    Data: d 
## 
## REML criterion at convergence: 775.5 
## 
## Random effects:
##  Groups   Name        Variance Std.Dev.
##  scenario (Intercept) 219      14.8    
##  subject  (Intercept) 616      24.8    
##  Residual             646      25.4    
## Number of obs: 83, groups: scenario, 7; subject, 6
## 
## Fixed effects:
##              Estimate Std. Error t value
## (Intercept)    256.85      16.12   15.94
## conditionpol   -19.72       5.58   -3.53
## genderM       -108.52      21.01   -5.16
## 
## Correlation of Fixed Effects:
##             (Intr) cndtnp
## conditionpl -0.173       
## genderM     -0.652  0.004
```


Note that we added “gender” as a fixed effect because the relationship between sex and pitch is systematic and predictable (i.e., we expect females to have higher pitch). This is different from the random effects subject and item, where the relationship between these and pitch is much more unpredictable and “random.”

Note that compared to our earlier model without the fixed effect gender, the variation that’s associated with the random effect “subject” dropped considerably. This is because the variation that’s due to gender was confounded with the variation that’s due to subject. The model didn’t know about males and females, and so it’s predictions were relatively more off, creating relatively larger residuals. 

We see that males and females differ by about 109 Hz. And the intercept is now much higher (256.846 Hz), as it now represents the female category (for the informal condition). The coefficient for the effect of attitude didn’t change much. 

Now we can compare our models using ANOVA, to see if one accounts for significantly more variance than another.


```r
politeness.null = lmer(pitch ~ gender + (1 | subject) + (1 | scenario), data = d)
summary(politeness.null)
```

```
## Linear mixed model fit by REML ['lmerMod']
## Formula: pitch ~ gender + (1 | subject) + (1 | scenario) 
##    Data: d 
## 
## REML criterion at convergence: 792.4 
## 
## Random effects:
##  Groups   Name        Variance Std.Dev.
##  scenario (Intercept) 206      14.4    
##  subject  (Intercept) 611      24.7    
##  Residual             751      27.4    
## Number of obs: 83, groups: scenario, 7; subject, 6
## 
## Fixed effects:
##             Estimate Std. Error t value
## (Intercept)    247.0       15.8   15.59
## genderM       -108.2       21.1   -5.14
## 
## Correlation of Fixed Effects:
##         (Intr)
## genderM -0.664
```

```r

anova(politeness.null, politeness.model2)
```

```
## Data: d
## Models:
## politeness.null: pitch ~ gender + (1 | subject) + (1 | scenario)
## politeness.model2: pitch ~ condition + gender + (1 | subject) + (1 | scenario)
##                   Df AIC BIC logLik deviance Chisq Chi Df Pr(>Chisq)    
## politeness.null    5 817 829   -403      807                            
## politeness.model2  6 807 822   -398      795  11.6      1    0.00065 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
```


This is known as a likelihood ratio test.

Now, you can summarize your results by saying something like, "Politeness affected pitch, $\chi^2$ (1) = 11.62, p = 0.00065), lowering it by about 19.7 Hz ± 5.6 Hz (standard errors).

You can also use the ANOVA function to look at the difference between additive and interactive models.


```r
politeness.model.int = lmer(pitch ~ condition * gender + (1 | subject) + (1 | 
    scenario), data = d)
summary(politeness.model.int)
```

```
## Linear mixed model fit by REML ['lmerMod']
## Formula: pitch ~ condition * gender + (1 | subject) + (1 | scenario) 
##    Data: d 
## 
## REML criterion at convergence: 766.8 
## 
## Random effects:
##  Groups   Name        Variance Std.Dev.
##  scenario (Intercept) 218      14.8    
##  subject  (Intercept) 617      24.8    
##  Residual             637      25.2    
## Number of obs: 83, groups: scenario, 7; subject, 6
## 
## Fixed effects:
##                      Estimate Std. Error t value
## (Intercept)            260.69      16.35   15.95
## conditionpol           -27.40       7.79   -3.52
## genderM               -116.20      21.73   -5.35
## conditionpol:genderM    15.57      11.10    1.40
## 
## Correlation of Fixed Effects:
##             (Intr) cndtnp gendrM
## conditionpl -0.238              
## genderM     -0.665  0.179       
## cndtnpl:gnM  0.167 -0.702 -0.252
```

```r

anova(politeness.model2, politeness.model.int)
```

```
## Data: d
## Models:
## politeness.model2: pitch ~ condition + gender + (1 | subject) + (1 | scenario)
## politeness.model.int: pitch ~ condition * gender + (1 | subject) + (1 | scenario)
##                      Df AIC BIC logLik deviance Chisq Chi Df Pr(>Chisq)
## politeness.model2     6 807 822   -398      795                        
## politeness.model.int  7 807 824   -397      793     2      1       0.16
```


## Random Slopes


```r
coef(politeness.model2)
```

```
## $scenario
##   (Intercept) conditionpol genderM
## 1       243.3       -19.72  -108.5
## 2       263.4       -19.72  -108.5
## 3       268.3       -19.72  -108.5
## 4       277.5       -19.72  -108.5
## 5       254.9       -19.72  -108.5
## 6       244.7       -19.72  -108.5
## 7       245.8       -19.72  -108.5
## 
## $subject
##    (Intercept) conditionpol genderM
## F1       242.9       -19.72  -108.5
## F2       267.3       -19.72  -108.5
## F3       260.3       -19.72  -108.5
## M3       285.2       -19.72  -108.5
## M4       262.2       -19.72  -108.5
## M7       223.1       -19.72  -108.5
## 
## attr(,"class")
## [1] "coef.mer"
```


You see from our model coefficients for the model:

`politeness.model2 = lmer(pitch ~ condition + gender + (1|subject) + (1|scenario), data=d)`

that each scenario and each subject is assigned a different intercept. That’s what we would expect, given that we’ve told the model with “(1|subject)” and “(1|scenario)” to take by-subject and by-item variability into account. 
 
But note also that the fixed effects (condition and gender) are all the same for all subjects and items. Our model is what is called a random intercept model. In this model, we account for baseline-differences in pitch, but we assume that whatever the effect of politeness is, it’s going to be the same for all subjects and items. 
 
But is that a valid assumption? In fact, often times it’s not – it is quite expected that some items would elicit more or less politeness. That is, the effect of politeness might be different for different items. Likewise, the effect of politeness might be different for different subjects. For example, it might be expected that some people are more polite, others less. So, what we need is a random slope model, where subjects and items are not only allowed to have differing intercepts, but where they are also allowed to have different slopes for the effect of politeness. 


```r
politeness.model.rs = lmer(pitch ~ condition + gender + (1 + condition | subject) + 
    (1 + condition | scenario), data = d)
summary(politeness.model.rs)
```

```
## Linear mixed model fit by REML ['lmerMod']
## Formula: pitch ~ condition + gender + (1 + condition | subject) + (1 +      condition | scenario) 
##    Data: d 
## 
## REML criterion at convergence: 775.1 
## 
## Random effects:
##  Groups   Name         Variance Std.Dev. Corr
##  scenario (Intercept)  203.56   14.27        
##           conditionpol  71.07    8.43    0.00
##  subject  (Intercept)  587.97   24.25        
##           conditionpol   1.48    1.22    1.00
##  Residual              627.45   25.05        
## Number of obs: 83, groups: scenario, 7; subject, 6
## 
## Fixed effects:
##              Estimate Std. Error t value
## (Intercept)    258.14      15.86   16.27
## conditionpol   -19.75       6.38   -3.10
## genderM       -111.11      20.94   -5.31
## 
## Correlation of Fixed Effects:
##             (Intr) cndtnp
## conditionpl -0.100       
## genderM     -0.660  0.002
```


Note that the only thing that we changed is the random effects, which now look a little more complicated. The notation “(1 + condition|subject)” means that you tell the model to expect differing baseline-levels of pitch (the intercept, represented by 1) as well as differing responses to the main factor in question, which is “condition” in this case. You then do the same for items, using the term "(1 + condition|scenario)."

Have a look at the coefficients of this updated model by typing in the following:


```r
coef(politeness.model.rs)
```

```
## $scenario
##   (Intercept) conditionpol genderM
## 1       244.5       -19.00  -111.1
## 2       261.9       -12.87  -111.1
## 3       270.9       -23.46  -111.1
## 4       277.1       -15.91  -111.1
## 5       255.8       -18.73  -111.1
## 6       247.0       -22.38  -111.1
## 7       249.7       -25.93  -111.1
## 
## $subject
##    (Intercept) conditionpol genderM
## F1       243.3       -20.50  -111.1
## F2       267.1       -19.30  -111.1
## F3       260.3       -19.65  -111.1
## M3       287.1       -18.30  -111.1
## M4       264.7       -19.43  -111.1
## M7       226.4       -21.35  -111.1
## 
## attr(,"class")
## [1] "coef.mer"
```


Now, the column with the by-subject and by-item coefficients for the effect of politeness (“conditionpol”) is different for each subject and item. Note, however, that it’s always negative and that many of the values are quite similar to each other. This means that despite individual variation, there is also consistency in how politeness affects the voice: for all of our speakers, the voice tends to go down when speaking politely, but for some people it goes down slightly more so than for others. 
 
Have a look at the column for gender. Here, the coefficients do no change. That is because we didn’t specify random slopes for the by-subject or by-item effect of gender.

Can we take a look at our random slopes?


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

(ggplot(d, aes(x=condition, y=pitch))
     #tell ggplot what data is, and x and y variables
     +facet_wrap(~subject,scales='free')
     #add a wrapping by unique combos of 2 variable
     #vary scales per facet.
     +geom_point()
     #add the points as representations
     +stat_smooth(method='lm',aes(group=1))
     #add the linear fits.
     )
```

```
## Warning: Removed 1 rows containing missing values (stat_smooth). Warning:
## Removed 1 rows containing missing values (geom_point).
```

![plot of chunk unnamed-chunk-12](figure/unnamed-chunk-12.png) 


## Some final notes about mixed modeling

There are a few important things to say here: You might ask yourself “Which random slopes should I specify?” … or even “Are random slopes necessary at all?” 
 
Conceptually, it makes a lot of sense to include random slopes along with random intercepts. After all, you can almost always expect that people differ with how they react to an experimental manipulation! And likewise, you can almost always expect that the effect of an experimental manipulation is not going to be the same for all of items in your experiment. 
 
In the model above, our whole study crucially rested on stating something about politeness. We were not interested in gender differences, but they are well worth controlling for. This is why we had random slopes for the effect of attitude (by subjects and item) but not gender. In other words, we only modeled by-subject and by-item variability in how politeness affects pitch. 

We've talked a lot about the different assumptions of the linear model. The good news is: Everything that we discussed in the context of the linear model applies straightforwardly to mixed models. So, you also have to worry about collinearity and outliers. And you have to worry about homoscedasticity (*equality of variance*) and potentially about lack of normality.

Independence, being the most important assumption, requires a special word: One of the main reasons we moved to mixed models rather than just working with linear models was to resolve non-independencies in our data. However, mixed models can still violate independence … if you’re missing important fixed or random effects. So, for example, if we analyzed our data with a model that didn’t include the random effect “subject”, then our model would not “know” that there are multiple responses per subject. This amounts to a violation of the independence assumption. So choose your fixed effects and random effects carefully, and always try to resolve non-independencies. 

### Some other notes:
If your dependent variable is…
- **Continuous:** use a linear regression model with mixed effects
- **Binary:** use a logistic regression model with mixed effects

Function `lmer` is used to fit linear mixed models, function `glmer` is used to fit generalized (non-Gaussian) linear mixed models.

## Exploring our homework data!

Now we'll try working with the data from upcoming homework 5 (that was also used in the tutorial in Week 0 if you were there!) to get used to using mixed models.

Let's read about our data in `kv0.csv`!

Our study design here features both between-subject factors (2 attention conditions) and within-subject factors (# of possible solutions to a word task, solving anagrams). The dependent variable was score on a memory test (higher numbers reflect better performance). There were 10 study participants divided between the two conditions; they each completed three problems in each category of # of possible solutions (1, 2, or 3).

This is a *repeated measures design*.  

The question we want to answer is: **How does score depend on attention and number of possible solutions?**

Variables:

* **subidr**: Subject ID

* **attnr**: 1 = divided attention condition; 2 = focused attention condition

* **num1**: only one solution to the anagram

* **num2**: two possible solutions to the anagram

* **num3**: three possible solutions to the anagram

Let's read in our data!


```r
d0 <- read.csv("http://www.stanford.edu/class/psych252/data/kv0.csv")

# load libraries needed for the lmer mixed-models and by subject plots
library(lme4)
library(ggplot2)


str(d0)
```

```
## 'data.frame':	20 obs. of  5 variables:
##  $ subidr: int  1 2 3 4 5 6 7 8 9 10 ...
##  $ attnr : Factor w/ 2 levels "divided","focused": 1 1 1 1 1 1 1 1 1 1 ...
##  $ num1  : int  2 3 3 5 4 5 5 5 2 6 ...
##  $ num2  : num  4 4 5 7 5 5 4.5 7 3 5 ...
##  $ num3  : int  7 5 6 5 8 6 6 8 7 6 ...
```


Note that our data is in *wide* or *short-form*: `'data.frame':  20 obs. of  5 variables` 

By short-form, we mean that the within-subject observations are displayed in separate columns, and each subject occupies a single row. 

We need the data in *long-form* for `lmer`. The function `reshape` is an economic way to convert between wide and long formats.


```r
d1 <- reshape(d0, direction = "long", idvar = "subidr", varying = list(c("num1", 
    "num2", "num3")), timevar = "num", v.names = "score")

head(d1)
```

```
##     subidr   attnr num score
## 1.1      1 divided   1     2
## 2.1      2 divided   1     3
## 3.1      3 divided   1     3
## 4.1      4 divided   1     5
## 5.1      5 divided   1     4
## 6.1      6 divided   1     5
```


Now the data is in long form: `'data.frame':  60 obs. of  4 variables`

The number of observations that we have in long format is equal to the number of observations in wide format times the product of levels of the repeated measures (within) variables.

In this case we only have one withing subject variable with 3 levels (number of possible solutions = 1, 2, or 3), so 20 * 3 = 60 observations

The added variables are identifiers now.

We can also use the function `melt()` from the `reshape2` package to get our data into long form.

Our `id.vars` are those variables that we want to be the same for each subject, and the `measure.vars` are those that are repeated measures on each subject:


```r
install.packages("reshape2")
```

```
## Error: trying to use CRAN without setting a mirror
```

```r
library(reshape2)

dl <- melt(d0, id.vars = c("subidr", "attnr"), measure.vars = c("num1", "num2", 
    "num3"))

head(dl)  # note 'variable' and 'value' names not specified
```

```
##   subidr   attnr variable value
## 1      1 divided     num1     2
## 2      2 divided     num1     3
## 3      3 divided     num1     3
## 4      4 divided     num1     5
## 5      5 divided     num1     4
## 6      6 divided     num1     5
```

```r

colnames(dl) <- c("id", "attn", "num", "score")
head(dl)
```

```
##   id    attn  num score
## 1  1 divided num1     2
## 2  2 divided num1     3
## 3  3 divided num1     3
## 4  4 divided num1     5
## 5  5 divided num1     4
## 6  6 divided num1     5
```

```r
str(dl)
```

```
## 'data.frame':	60 obs. of  4 variables:
##  $ id   : int  1 2 3 4 5 6 7 8 9 10 ...
##  $ attn : Factor w/ 2 levels "divided","focused": 1 1 1 1 1 1 1 1 1 1 ...
##  $ num  : Factor w/ 3 levels "num1","num2",..: 1 1 1 1 1 1 1 1 1 1 ...
##  $ score: num  2 3 3 5 4 5 5 5 2 6 ...
```


Basically, we now have a long-form dataframe with 3 rows for each subject.

### Setting up variables

Since the levels of 'num' were created from the original column names (i.e., num1, num2, num3), R interprets the 'num' variable as a factor. However, we want to treat num as a quantitative variable, and need to force num to be numeric. We also want the subject id ('id') to be a factor:


```r
dl$num <- as.numeric(dl$num)
dl$id <- factor(dl$id)
```


We also need to rescale `id` to 1:10 within each level of `attn`, since the subject id ('id') is 11:20 when `attn` is 'focused'. So we need to select only these values of 'id', and transform them to 1:10. This requires creating a new variable, cond.id, in the dataframe, dl.


```r
dl$cond.id <- as.numeric(dl$id)
dl$cond.id[dl$attn == "focused"] = dl$cond.id[dl$attn == "focused"] - 10
```


Now that we have our dataset ready to go, try plotting the data, and creating and comparing some mixed models using this data. 

There are some hints and suggested analyses at the bottom of this document, but try to explore on your own, create your own R script and then compare! Feel free to work with anyone sitting around you.

### Possible analyses

Start with a simple regression ans only random effect of intercept

```r
res1 <- lmer(score ~ num + (1 | id), dl)
summary(res1)
```

```
## Linear mixed model fit by REML ['lmerMod']
## Formula: score ~ num + (1 | id) 
##    Data: dl 
## 
## REML criterion at convergence: 214.3 
## 
## Random effects:
##  Groups   Name        Variance Std.Dev.
##  id       (Intercept) 1.04     1.02    
##  Residual             1.40     1.19    
## Number of obs: 60, groups: id, 20
## 
## Fixed effects:
##             Estimate Std. Error t value
## (Intercept)    4.758      0.465    10.2
## num            0.600      0.187     3.2
## 
## Correlation of Fixed Effects:
##     (Intr)
## num -0.807
```


The regression is singnificant and interpretable as usual

Regression equation:

$score$ = 4.76 + .6 * $num$

Let's visualize what we're modeling with the random intercept model.

(ggplot(dl, aes(x=num, y=score))
     #tell ggplot what data is, and x and y variables
     +facet_wrap(~subidr,ncol=5,scales='free')
     #add a wrapping by unique combos of 2 variable
     #set num columns, and vary scales per facet.
     +geom_point()
     #add the points as representations
     +stat_smooth(method='lm',aes(group=1))
     #add the linear fits.
)

# note that the means for every subject are at slightly different score levels. there is even more varuability in the slpes of the lines. We can capture those with anothe random effects term. 

# intercept and slope lmer
res2<-lmer(score ~ num + (1+num|subidr), d1)
summary(res2)
# note that we now have more coefficients in the random effects table and our main effects reduced in significance 
# is the variance in terms of intercept and slope enough that we need both random terms. we can formally answer this question in the usual sense. 

anova(res1,res2)
# it seems like we do! Now you have a research or a moral dilemma. Do you try to figure out what's causing the variance in slope and intercept? Do you push the simpler but worse model?

# Think about it while eating turkey!
```