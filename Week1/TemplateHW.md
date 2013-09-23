Template Homework
========================================================

To submit your homework, you'll create an RMarkdown (.Rmd) script to upload to Coursework. This will allow the TAs to create an easy-to-read document to grade. You will also get to practice using scripts to keep track of the analyses you run and organize your output, so that it's easy to document what you've done while looking at a dataset.

Below are some basics for using RMarkdown.

One thing that's nice about RMarkdown is that you can clearly differentiate sections of code from commentary about what you are trying to do. When you want to include sections of code, you mark them off by using the header and footer below.

Inserting an R Script:

```r
summary(cars)
```

```
##      speed           dist    
##  Min.   : 4.0   Min.   :  2  
##  1st Qu.:12.0   1st Qu.: 26  
##  Median :15.0   Median : 36  
##  Mean   :15.4   Mean   : 43  
##  3rd Qu.:19.0   3rd Qu.: 56  
##  Max.   :25.0   Max.   :120
```


You can name the "chunks" of code so that you remember what each section of code does. Then, you can jump to chunks of code (which makes it easy to search through your document), and run each chunk separately. Below is the same chunk of code as above with a "name" included:


```r
summary(cars)
```

```
##      speed           dist    
##  Min.   : 4.0   Min.   :  2  
##  1st Qu.:12.0   1st Qu.: 26  
##  Median :15.0   Median : 36  
##  Mean   :15.4   Mean   : 43  
##  3rd Qu.:19.0   3rd Qu.: 56  
##  Max.   :25.0   Max.   :120
```


You can also embed plots, for example:


```r
plot(cars)
```

![plot of chunk unnamed-chunk-2](figure/unnamed-chunk-2.png) 


In this case, the information included in the "name" of the chunk specifies the dimensions of the plot.

After creating a .Rmd document, you can easily convert the script into HTML by hitting the "Knit HTML" button - try it out and see how nice it looks!

Below, we have worked through Question 9 Parts A&B so you get an idea of how to format your homework.

9)
A. First, we calculated the mean of the non-normal distribution D0. 


```r
x0 = c(1:3, 5, 7, 9)
p0 = c(0.2, 0.4, 0.24, 0.1, 0.05, 0.01)
mu0 = sum(x0 * p0)/sum(p0)
print(mu0)
```

```
## [1] 2.66
```


The mean of D0 was 2.66.

B. Next, we drew a sample of 1000 observations from the skewed distribution x0.


```r
o1 = sample(x0, 1000, replace = T, prob = p0)
```


Then, we plotted a histogram of x0 was along with the estimated probability density function.


```r
rs1 = hist(o1, prob = T, main = "Sampling distrn of x0, 1000 Samples")
lines(density(o1, adjust = 3))
```

![plot of chunk unnamed-chunk-3](figure/unnamed-chunk-3.png) 


