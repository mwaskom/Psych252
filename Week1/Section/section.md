
**Steph Gagnon**, Homework 1, 10/02/13
=======================================
  
Question 1
-----------------------------------------

### Q1 b-i)
  

```r
deaths = c(11, 15, 15, 16, 25, 20)
m_deaths = mean(deaths)
print(m_deaths)
```

```
## [1] 17
```

```r
var_deaths = var(deaths)
print(var_deaths)
```

```
## [1] 23.6
```

```r

sd_deaths = sd(deaths)
print(sd_deaths)
```

```
## [1] 4.858
```

```r
var_deaths2 = sd_deaths^2
print(var_deaths2)
```

```
## [1] 23.6
```


For this sample.... the mean is 17 deaths, the standard...


### Q1, b-ii


```r
n = length(deaths)
se_deaths = sd_deaths/sqrt(n)
print(se_deaths)
```

```
## [1] 1.983
```



### Q1, b-iii

T = k * $\bar x$, where = 17. T=17k.


### Q1, b-iv

T = 17k
Y = bX
sd(Y) = 17 * 1.9833.


### Example distributions using linear transformation:

```r
k = 1
year1 <- data.frame(length = rnorm(1000, mean = m_deaths * k, se_deaths * k))
k = 2
year2 <- data.frame(length = rnorm(1000, mean = m_deaths * k, se_deaths * k))
k = 3
year3 <- data.frame(length = rnorm(1000, mean = m_deaths * k, se_deaths * k))
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
-------------------

setwd("~/Class/Psych252/Week1/Section")
### 2.a)

**Load in data:**

```r
d0 = read.csv("earlydeaths.csv")

```



















