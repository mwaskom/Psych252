**Jane Doe**, Homework 1, 9/23/13
=======================================
  
Question 9
-----------------------------------------

### Q9 Part A

First, we calculated the mean of the non-normal distribution `D0`. 
  

```r
x0 = c(1:3, 5, 7, 9)
p0 = c(0.2, 0.4, 0.24, 0.1, 0.05, 0.01)
mu0 = sum(x0 * p0)/sum(p0)
print(mu0)
```

```
## [1] 2.66
```


The mean of `D0` is 2.66.

**Instructor's Note:** You could also write your narrative text as follows, which will ensure that the number you report is always in sync with the code you wrote. This is a bit more complex, but recommended:

The mean of `D0` is 2.66.

### Q9 Part B 

Next, we drew a sample of 1000 observations from the skewed distribution `x0`.
  

```r
o1 = sample(x0, 1000, replace = T, prob = p0)
```


Then, we made a histogram of `x0` along with the estimated probability density function.


```r
rs1 = hist(o1, prob = T, main = "Sampling distribution of x0, 1000 Samples")
lines(density(o1, adjust = 3))
```

![plot of chunk 9b_histogram](figure/9b_histogram.png) 

