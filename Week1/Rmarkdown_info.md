R Markdown Basics
=================

### Intro
To submit your homework, you'll create an RMarkdown (.Rmd) script and upload it to Coursework. This will allow the TAs to create an easy-to-read document to grade; more importantly, you will also get to practice *(1)* writing scripts, *(2)* keeping track of the analyses you run, and *(3)* organizing your output. 

One thing that's nice about RMarkdown is that you can clearly differentiate **sections of code** from **commentary about what you are trying to do**. When you want to include sections of code, you mark them off by using the header and footer below.


### Formatting homework questions
In the document `Template_HW.R` we have worked through Question 9 Parts A&B so you get an idea of how to format your homework. Check that out!


Below are some basics for using RMarkdown (also, check out [this website](http://www.rstudio.com/ide/docs/authoring/using_markdown) for more info!).


Inserting an R Script
---------------------

R code is "fenced" off by three **backticks** along with the code `{r}`, to make clear what language the code is in:


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


You can name these **"chunks"** of code so that you remember what each section of code does. Then, you can jump to chunks of code (which makes it easy to search through your document), and run each chunk separately. Below is the same chunk of code as above with a "name" included:


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


You can also reference R variables directly in your narrative text. That way, when you're reporting the result of some analysis, you can be confident that the value in your write-up corresponds directly with the code you have written:


```r
mean_speed <- mean(cars$speed)
```


The mean speed of the cars in our database is 15.4.

Embedded Plots
--------------

You can also embed plots, for example:


```r
plot(cars)
```

![plot of chunk cars_plot](figure/cars_plot.png) 


When plotting, the chunk name is used as the name for the static image file that will be saved to your computer. In addition to the name of the chunk, when you are creating a plot you can pass keyword arguments with display options that control things like the size of the resulting image.

After creating a .Rmd document, you can easily convert the script into HTML by hitting the **"Knit HTML"** button - try it out and see how nice it looks! Importantly, both the R output and the plots are embedded in the document right next to the narrative explanation of your analysis and the code that is actually performing it.


Some formatting tips
---------------------

**Double astericks bold the text**, 
*a single asterick italicizes*, 
`back-ticks make the font look like code`


Double underline (the equals sign) is the biggest header
========================================================
You should use this header for your Name, HW #, and Date

A single underline is the next biggest header
----------------------------------------------
You should use this to label questions.

### A triple hashtag is the smallest header
Use this header for the parts of questions!
