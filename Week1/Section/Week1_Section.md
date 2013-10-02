Section, Week 1
=======================================
  
Question 1
-----------------------------------------

### 1.b-i)
**Calculate stats for maltreatment deaths:**

```r
deaths = c(11, 15, 15, 16, 25, 20)
m_deaths = mean(deaths)
s_deaths = sd(deaths)
var_deaths = var(deaths)
var_deaths_v2 = s_deaths^2
```

Over the period from 1990-1995, was a **mean** of 17 juvenile deaths per year caused by maltreatment. The **variance** in these maltreatment deaths was 23.6. The **standard deviation** of the same maltreatment deaths was 4.858.

### 1.b-ii)
**Calculate standard error of the mean:**

```r
n = length(deaths)
se_deaths = s_deaths/(sqrt(n))
```

For a sample of 6, the **standard error** of $latex {\bar x}$ = 1.9833.

### 1.b-iii)
The algebraic equation for the estimated number (`T`) of maltreatment deaths in the period of `k` years is: 

T = 17 * k

As `k` increases, the total (T) increases linearly as a function of the mean number of deaths (i.e., 17).

### 1.b-iv)
The standard deviation of the statistic (T) = `k *` sd(X). In this case, sd(X) is equal to the **standard error** of the sample mean ($latex {\bar x}$), calculated in **1b-ii**; thus sd(T) = `k *` 1.9833. 

### Example distributions using linear transformation:

```r
k = 1
year1 <- data.frame(length = rnorm(1000, mean = m_deaths, s_deaths))
k = 2
year2 <- year1 + data.frame(length = rnorm(1000, mean = m_deaths, s_deaths))
k = 3
year3 <- year2 + data.frame(length = rnorm(1000, mean = m_deaths, s_deaths))
```



```r
# Now, combine your two dataframes into one.  First make a new column in
# each.
year1$NumberYears <- "1 year"
year2$NumberYears <- "2 years"
year3$NumberYears <- "3 years"

# and combine into your new data frame all_years
all_years <- rbind(year1, year2, year3)

library(ggplot2)
# now make your histogram
ggplot(all_years, aes(length, fill = NumberYears)) + geom_histogram(alpha = 0.5, 
    colour = "darkgray", aes(y = ..density..), position = "identity")
```

```
## stat_bin: binwidth defaulted to range/30. Use 'binwidth = x' to adjust
## this.
```

![plot of chunk plot distributions](figure/plot_distributions.png) 


Question 2
-----------------------------------------

### 2.a)
Here we will use the data in `earlydeaths.csv` to generate a **cross-tabulation**. This will indicate if there is a relationship between the variables `time` and `cause` (cause of death), which we will formally test in **2b**.

**Load in data:**

```r
# load in data
d0 = read.csv("earlydeaths.csv")
str(d0)
```

```
## 'data.frame':	350 obs. of  2 variables:
##  $ time : int  1 1 1 1 1 1 1 1 1 1 ...
##  $ cause: Factor w/ 2 levels "maltreat","other": 1 1 1 1 1 1 1 1 1 1 ...
```

```r
summary(d0)
```

```
##       time           cause    
##  Min.   :1.00   maltreat:102  
##  1st Qu.:1.00   other   :248  
##  Median :2.00                 
##  Mean   :2.15                 
##  3rd Qu.:3.00                 
##  Max.   :3.00
```


**Change levels of `cause` to match the cross-tab in homework:**

```r
levels(d0$cause)
```

```
## [1] "maltreat" "other"
```

```r
levels(d0$cause)[1] = "Maltreat"
levels(d0$cause)[2] = "Non-Maltr"
levels(d0$cause)
```

```
## [1] "Maltreat"  "Non-Maltr"
```


**Generate cross-tabulation of `time` by `cause`:**

```r
# Print the table
print(table(d0$cause, d0$time))
```

```
##            
##               1   2   3
##   Maltreat   26  31  45
##   Non-Maltr  68  80 100
```

```r

# Print table with margins, like in hw
tx = addmargins(table(d0$cause, d0$time, dnn = c("Cause", "Time")))
print(tx)
```

```
##            Time
## Cause         1   2   3 Sum
##   Maltreat   26  31  45 102
##   Non-Maltr  68  80 100 248
##   Sum        94 111 145 350
```



### 2.b)

```r
# Print the table summary (i.e., chi-squared contingency test)
rs1 = summary(table(d0$cause, d0$time))
print(rs1)
```

```
## Number of cases in table: 350 
## Number of factors: 2 
## Test for independence of all factors:
## 	Chisq = 0.4, df = 2, p-value = 0.8
```

```r

# access variables from this output 'object'
chisq = rs1$statistic
df = rs1$parameter
pval = rs1$p.value
```


To test the null hypothesis that there is no relationship between the cause of juvenile deaths (`cause`) and time (`time`), we conducted a **chi-squared contingency test**. Results indicate that there is not a significant relationship between the cause of deaths and time, $latex {\chi^2}$(2) = 0.4308, *p* = 0.8062. In other words, the time trend in the number of deaths is similar regardless of the cause of death.

**n.b., you can write stats output in the following ways:**
$latex {\chi^2}$(2) = 0.4308, *p* = 0.8062;
X^2 (2) = 0.43, *p* = 0.81.

If you decide to use latex, [this site](http://www.calvin.edu/~rpruim/courses/m343/F12/RStudio/LatexExamples.html) is a helpful resource!

Question 8
-----------------------------------------
### 8.a)
**Create variable storing population size for age ranges:**

```r
census_pop = c(72.3, 46.5, 43.2, 42.5, 41.9, 35)
```


**Calculate size of sub-population >18 years old:**

```r
pop_Over18 = sum(census_pop) - census_pop[1]
```

The size of the sub-population of likely voters is 209.1.

**Calculate proportion of likely voters by age category:**

```r
p_likelyvoters = census_pop[2:6]/pop_Over18
```

The proportions of likely voters for the age categories over 18 are: 0.2224, 0.2066, 0.2033, 0.2004, 0.1674.

### 8.b)
**Load in data from fieldsimul1.csv:**

```r
d1 = read.csv("fieldsimul1.csv")
str(d1)
```

```
## 'data.frame':	200 obs. of  7 variables:
##  $ recall : int  1 1 1 1 1 1 1 1 1 1 ...
##  $ prop54 : int  1 1 1 1 1 1 1 1 1 1 ...
##  $ party  : int  1 1 1 1 1 1 1 1 1 1 ...
##  $ age    : int  49 44 46 50 25 28 21 20 22 73 ...
##  $ optmism: int  7 8 7 7 6 7 5 5 6 8 ...
##  $ agecat : int  45 45 45 45 24 24 24 24 24 70 ...
##  $ recallq: int  1 1 1 1 1 1 1 1 1 1 ...
```

```r
summary(d1)
```

```
##      recall         prop54         party           age      
##  Min.   :1.00   Min.   :1.00   Min.   :1.00   Min.   :20.0  
##  1st Qu.:1.00   1st Qu.:1.00   1st Qu.:1.00   1st Qu.:37.0  
##  Median :1.00   Median :2.00   Median :2.00   Median :48.0  
##  Mean   :1.51   Mean   :1.78   Mean   :1.75   Mean   :48.3  
##  3rd Qu.:2.00   3rd Qu.:2.00   3rd Qu.:2.00   3rd Qu.:58.0  
##  Max.   :3.00   Max.   :3.00   Max.   :3.00   Max.   :75.0  
##     optmism          agecat        recallq      
##  Min.   : 0.00   Min.   :24.0   Min.   :-1.000  
##  1st Qu.: 4.00   1st Qu.:35.0   1st Qu.:-1.000  
##  Median : 6.00   Median :45.0   Median : 1.000  
##  Mean   : 5.62   Mean   :48.1   Mean   : 0.115  
##  3rd Qu.: 7.00   3rd Qu.:57.0   3rd Qu.: 1.000  
##  Max.   :11.00   Max.   :70.0   Max.   : 1.000
```


**Recode age into categorical variable using 5 age categories:**

```r
d1$agecat0 = findInterval(d1$age, c(30, 40, 50, 66))
d1$agecat0 = d1$agecat0 + 1  # group 1 starts at 1
d1$agecat0 = factor(d1$agecat0)  # convert to categorical var
head(d1)
```

```
##   recall prop54 party age optmism agecat recallq agecat0
## 1      1      1     1  49       7     45       1       3
## 2      1      1     1  44       8     45       1       3
## 3      1      1     1  46       7     45       1       3
## 4      1      1     1  50       7     45       1       4
## 5      1      1     1  25       6     24       1       1
## 6      1      1     1  28       7     24       1       1
```


### 8.c)


```r
rs4 = chisq.test(table(d1$agecat0), p = p_likelyvoters, simulate.p.value = FALSE)
print(rs4)
```

```
## 
## 	Chi-squared test for given probabilities
## 
## data:  table(d1$agecat0)
## X-squared = 19.88, df = 4, p-value = 0.0005268
```

```r

# Note this format also gives the same results:
rs4_v2 = chisq.test(table(d1$agecat0), p = census_pop[2:6], rescale.p = TRUE, 
    simulate.p.value = FALSE)
print(rs4_v2)
```

```
## 
## 	Chi-squared test for given probabilities
## 
## data:  table(d1$agecat0)
## X-squared = 19.88, df = 4, p-value = 0.0005268
```


Explain results....


```r
p_observed = table(d1$agecat0)/length(d1$agecat0)
p_expected = p_likelyvoters

df_cat = rbind(p_observed, p_expected)
barplot(df_cat, col = c("darkblue", "red"), xlab = ("Age Category"), ylab = "Proportion", 
    legend = rownames(df_cat), beside = TRUE)
```

![plot of chunk 8c_plot_proportions](figure/8c_plot_proportions.png) 


### 8.d)

```r
d1$party = factor(d1$party)
levels(d1$party) = c("Dem", "Rep", "Other")

d1$recall = factor(d1$recall)
levels(d1$recall) = c("Yes", "No", "Unsure")

head(d1)
```

```
##   recall prop54 party age optmism agecat recallq agecat0
## 1    Yes      1   Dem  49       7     45       1       3
## 2    Yes      1   Dem  44       8     45       1       3
## 3    Yes      1   Dem  46       7     45       1       3
## 4    Yes      1   Dem  50       7     45       1       4
## 5    Yes      1   Dem  25       6     24       1       1
## 6    Yes      1   Dem  28       7     24       1       1
```



```r
table(d1$recall, d1$party)
```

```
##         
##          Dem Rep Other
##   Yes     40  49    18
##   No      43  25    16
##   Unsure   3   4     2
```

```r

# Print table with margins
tx = addmargins(table(d1$recall, d1$party, dnn = c("Recall", "Party")))
print(tx)
```

```
##         Party
## Recall   Dem Rep Other Sum
##   Yes     40  49    18 107
##   No      43  25    16  84
##   Unsure   3   4     2   9
##   Sum     86  78    36 200
```

```r

# Run chi-squared test
rs5 = chisq.test(table(d1$recall, d1$party))
```

```
## Warning: Chi-squared approximation may be incorrect
```

```r
print(rs5)
```

```
## 
## 	Pearson's Chi-squared test
## 
## data:  table(d1$recall, d1$party)
## X-squared = 5.687, df = 4, p-value = 0.2238
```


Explain results...


```r
d3 = d1[d1$recall != "Unsure", ]
str(d3)  # note the 3 levels of recall still!
```

```
## 'data.frame':	191 obs. of  8 variables:
##  $ recall : Factor w/ 3 levels "Yes","No","Unsure": 1 1 1 1 1 1 1 1 1 1 ...
##  $ prop54 : int  1 1 1 1 1 1 1 1 1 1 ...
##  $ party  : Factor w/ 3 levels "Dem","Rep","Other": 1 1 1 1 1 1 1 1 1 1 ...
##  $ age    : int  49 44 46 50 25 28 21 20 22 73 ...
##  $ optmism: int  7 8 7 7 6 7 5 5 6 8 ...
##  $ agecat : int  45 45 45 45 24 24 24 24 24 70 ...
##  $ recallq: int  1 1 1 1 1 1 1 1 1 1 ...
##  $ agecat0: Factor w/ 5 levels "1","2","3","4",..: 3 3 3 4 1 1 1 1 1 5 ...
```

```r
d3$recall = factor(d3$recall)

rs6 = chisq.test(table(d3$recall, d3$party))
print(rs6)
```

```
## 
## 	Pearson's Chi-squared test
## 
## data:  table(d3$recall, d3$party)
## X-squared = 5.317, df = 2, p-value = 0.07004
```


Explain results...

## 8.e)
**Re-code recall as quantitative variable:**

```r
d1$recallq = as.numeric(d1$recall)
d1$recallq = 1 * as.numeric(d1$recallq == 1) + (-1) * as.numeric(d1$recallq == 
    2) + 0 * as.numeric(d1$recallq == 3)

summary(d1)
```

```
##     recall        prop54       party         age          optmism     
##  Yes   :107   Min.   :1.00   Dem  :86   Min.   :20.0   Min.   : 0.00  
##  No    : 84   1st Qu.:1.00   Rep  :78   1st Qu.:37.0   1st Qu.: 4.00  
##  Unsure:  9   Median :2.00   Other:36   Median :48.0   Median : 6.00  
##               Mean   :1.78              Mean   :48.3   Mean   : 5.62  
##               3rd Qu.:2.00              3rd Qu.:58.0   3rd Qu.: 7.00  
##               Max.   :3.00              Max.   :75.0   Max.   :11.00  
##      agecat        recallq       agecat0
##  Min.   :24.0   Min.   :-1.000   1:24   
##  1st Qu.:35.0   1st Qu.:-1.000   2:38   
##  Median :45.0   Median : 1.000   3:44   
##  Mean   :48.1   Mean   : 0.115   4:60   
##  3rd Qu.:57.0   3rd Qu.: 1.000   5:34   
##  Max.   :70.0   Max.   : 1.000
```


## 8.f)

```r
interaction.plot(d1$agecat0, d1$party, d1$recallq, xlab = "Age Category", ylab = "Recall")
```

![plot of chunk 8f_plot_recallq-vs-agecat0_byparty](figure/8f_plot_recallq-vs-agecat0_byparty.png) 


## 8.g)

```r
str(d1)
```

```
## 'data.frame':	200 obs. of  8 variables:
##  $ recall : Factor w/ 3 levels "Yes","No","Unsure": 1 1 1 1 1 1 1 1 1 1 ...
##  $ prop54 : int  1 1 1 1 1 1 1 1 1 1 ...
##  $ party  : Factor w/ 3 levels "Dem","Rep","Other": 1 1 1 1 1 1 1 1 1 1 ...
##  $ age    : int  49 44 46 50 25 28 21 20 22 73 ...
##  $ optmism: int  7 8 7 7 6 7 5 5 6 8 ...
##  $ agecat : int  45 45 45 45 24 24 24 24 24 70 ...
##  $ recallq: num  1 1 1 1 1 1 1 1 1 1 ...
##  $ agecat0: Factor w/ 5 levels "1","2","3","4",..: 3 3 3 4 1 1 1 1 1 5 ...
```

```r

# additive model
rs_add = lm(recallq ~ agecat0 + party, data = d1)
summary(rs_add)
```

```
## 
## Call:
## lm(formula = recallq ~ agecat0 + party, data = d1)
## 
## Residuals:
##    Min     1Q Median     3Q    Max 
## -1.664 -1.010  0.574  0.909  1.342 
## 
## Coefficients:
##             Estimate Std. Error t value Pr(>|t|)   
## (Intercept)   0.2512     0.2018    1.24   0.2148   
## agecat02     -0.5929     0.2568   -2.31   0.0220 * 
## agecat03     -0.2408     0.2510   -0.96   0.3386   
## agecat04     -0.3534     0.2341   -1.51   0.1328   
## agecat05     -0.2347     0.2585   -0.91   0.3650   
## partyRep      0.4125     0.1572    2.62   0.0094 **
## partyOther    0.0805     0.1937    0.42   0.6780   
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 0.96 on 193 degrees of freedom
## Multiple R-squared:  0.0561,	Adjusted R-squared:  0.0267 
## F-statistic: 1.91 on 6 and 193 DF,  p-value: 0.0809
```

```r

# interactive model
rs_inter = lm(recallq ~ agecat0 * party, data = d1)
summary(rs_inter)
```

```
## 
## Call:
## lm(formula = recallq ~ agecat0 * party, data = d1)
## 
## Residuals:
##    Min     1Q Median     3Q    Max 
## -1.500 -1.069  0.583  0.833  1.769 
## 
## Coefficients:
##                     Estimate Std. Error t value Pr(>|t|)   
## (Intercept)           0.2500     0.2401    1.04    0.299   
## agecat02             -1.0192     0.3587   -2.84    0.005 **
## agecat03             -0.1667     0.3668   -0.45    0.650   
## agecat04             -0.1810     0.2991   -0.61    0.546   
## agecat05             -0.2500     0.3396   -0.74    0.463   
## partyRep              0.2500     0.5370    0.47    0.642   
## partyOther            0.2500     0.5370    0.47    0.642   
## agecat02:partyRep     0.9002     0.6350    1.42    0.158   
## agecat03:partyRep     0.0833     0.6354    0.13    0.896   
## agecat04:partyRep    -0.2320     0.6002   -0.39    0.700   
## agecat05:partyRep     0.0833     0.7070    0.12    0.906   
## agecat02:partyOther   0.0192     0.7681    0.03    0.980   
## agecat03:partyOther  -0.3333     0.6932   -0.48    0.631   
## agecat04:partyOther  -0.3190     0.6599   -0.48    0.629   
## agecat05:partyOther  -0.0833     0.6503   -0.13    0.898   
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 0.961 on 185 degrees of freedom
## Multiple R-squared:  0.0937,	Adjusted R-squared:  0.0252 
## F-statistic: 1.37 on 14 and 185 DF,  p-value: 0.173
```

```r

# quadratic trend of age?
d1$agecat0 = as.numeric(d1$agecat0)
str(d1)
```

```
## 'data.frame':	200 obs. of  8 variables:
##  $ recall : Factor w/ 3 levels "Yes","No","Unsure": 1 1 1 1 1 1 1 1 1 1 ...
##  $ prop54 : int  1 1 1 1 1 1 1 1 1 1 ...
##  $ party  : Factor w/ 3 levels "Dem","Rep","Other": 1 1 1 1 1 1 1 1 1 1 ...
##  $ age    : int  49 44 46 50 25 28 21 20 22 73 ...
##  $ optmism: int  7 8 7 7 6 7 5 5 6 8 ...
##  $ agecat : int  45 45 45 45 24 24 24 24 24 70 ...
##  $ recallq: num  1 1 1 1 1 1 1 1 1 1 ...
##  $ agecat0: num  3 3 3 4 1 1 1 1 1 5 ...
```

```r

# additive model w/quadratic effect of age category
rs_add_polyage = lm(recallq ~ poly(agecat0, 2) + party, data = d1)
summary(rs_add_polyage)
```

```
## 
## Call:
## lm(formula = recallq ~ poly(agecat0, 2) + party, data = d1)
## 
## Residuals:
##    Min     1Q Median     3Q    Max 
## -1.492 -0.990  0.619  0.857  1.141 
## 
## Coefficients:
##                   Estimate Std. Error t value Pr(>|t|)  
## (Intercept)        -0.0531     0.1053   -0.50    0.615  
## poly(agecat0, 2)1  -0.1038     0.9754   -0.11    0.915  
## poly(agecat0, 2)2   1.2008     1.0101    1.19    0.236  
## partyRep            0.3907     0.1567    2.49    0.013 *
## partyOther          0.0873     0.1929    0.45    0.652  
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 0.966 on 195 degrees of freedom
## Multiple R-squared:  0.0334,	Adjusted R-squared:  0.0136 
## F-statistic: 1.69 on 4 and 195 DF,  p-value: 0.155
```

```r

# interactive model w/quadratic effect of age category
rs_inter_polyage = lm(recallq ~ poly(agecat0, 2) * party, data = d1)
summary(rs_inter_polyage)
```

```
## 
## Call:
## lm(formula = recallq ~ poly(agecat0, 2) * party, data = d1)
## 
## Residuals:
##    Min     1Q Median     3Q    Max 
## -1.538 -0.937  0.590  0.840  1.172 
## 
## Coefficients:
##                              Estimate Std. Error t value Pr(>|t|)  
## (Intercept)                   -0.0557     0.1071   -0.52    0.603  
## poly(agecat0, 2)1              0.7213     1.3683    0.53    0.599  
## poly(agecat0, 2)2              1.4501     1.4453    1.00    0.317  
## partyRep                       0.3571     0.1624    2.20    0.029 *
## partyOther                     0.0752     0.2012    0.37    0.709  
## poly(agecat0, 2)1:partyRep    -2.4117     2.3478   -1.03    0.306  
## poly(agecat0, 2)2:partyRep    -1.2084     2.4757   -0.49    0.626  
## poly(agecat0, 2)1:partyOther  -0.9886     2.6127   -0.38    0.706  
## poly(agecat0, 2)2:partyOther   0.6676     2.5954    0.26    0.797  
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 0.973 on 191 degrees of freedom
## Multiple R-squared:  0.0409,	Adjusted R-squared:  0.000749 
## F-statistic: 1.02 on 8 and 191 DF,  p-value: 0.423
```


Explain output...


