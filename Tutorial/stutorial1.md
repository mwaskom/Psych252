Introduction to Statistical Computing with R
============================================

Based on notes by Paul Thibodeau (2009) and revisions by the Psych 252 instructors in 2010 and 2011

Expanded in 2012 by Mike Frank, Benoit Monin and Ewart Thomas

Converted to [R Markdown](http://www.rstudio.com/ide/docs/r_markdown) format and further expanded in 2013 by Michael Waskom.

2013 TAs: Stephanie Gagnon, Lauren Howe, Michael Waskom, Alyssa Fu, Kevin Mickey, Eric Miller

*If you haven't already installed R, it is availible [here](http://www.r-project.org/).*

Brief notes about learning R
----------------------------

The data analysis environment we'll be using for Psych 252 is R. R is a programming language that is specifically designed for statistical computation. It has many appealing features: it is powerful, flexible, and widely used in the statistical community. The aspects that make R so powerful and flexible, however, contribute to a learning curve that is relatively steeper than what you might find in point-and-click packages like SPSS. The aim of this tutorial is to provide a general introduction to interacting with R that will reduce the feelings of frustration and helplessness that can emerge early in ones relationship with it. Although this tutorial doesn't assume any preexisting knowledge, if you've had no experience with computer programming there may be some parts of it that are confusing or lack a particularly deep meaning. Try your best to understand them now, but you will also likely benefit from returning to the tutorial periodically as you become more comfortable.

The most important skill to cultivate up front is the ability to help yourself when you are stuck. Fortunately, R is pretty helpful in this regard. R is what's known as an *interpreted langauge*, which basically means that there is a console you type commands into and get immediate feedback on them. Do this liberally as you work though the tutorial and the early class exercises, making small modifications to the examples we provide until you feel like you really understand what's going on.

The console is also your gateway to the built-in help functionality. Almost all R functions (more later on what those are) have help files built in that will provide you with useful information about what those functions do and how to use them. You find this by typing `help(function)` (or `?function`), where I am using "function" as a stand-in for the name you actually want to know about. It's important to read these files closely the first time you encounter a function, but it's *also* (possibly more) important to refer back to them frequently. I read once that a prominent distinction between an experienced programmer and a novice is the longer latency for the novice to look up the help for something confusing (but the direction of causality is not clear!). If you have a sense for what you want to do, but don't know or can't remember the exact function that will do it, you can search through the help files for a term with two question marks (e.g. `??regression`).

Of course, the internet is also a useful resource. Because of its name, it can be a little annoying to google for help with R. The [rseek](http://rseek.org/) website is intended to remedy this problem by acting as an R-specific search engine. A somewhat more useful resource, in my opinion, is the [stackoverflow](http://stackoverflow.com/) website. Because this is a general-purpose resource for programming help, it will be useful to use the R tag (`[R]`) in your queries. A related resource is the [statistics stackexchange](http://stats.stackexchange.com/), which is like Stack Overflow but focused more on the underlying statistical issues.

Finally, a note on errors. Novice and expert programmers alike will frequently run into errors in their R code. When this happens, processing will halt and an error message will be printed to the console. This is usually more frustrating for the novice, as the error often occurs deep within some function and the message bears no direct correspondence to what they were trying to do. A common beginner mistake is to conclude that the error message is gibberish and resign oneself to woe and dismay. It's important to resist this urge; even if the error message is not immediately informative, it is intended to precisely convey some piece of information, and usually understanding what this information is will be the key to solving the problem.

Basic interaction with the R console
------------------------------------

At its least useful, you can treat R like a calculator for basic computations. Just type some mathematical expression into the console, and the result will be displayed on the following line.


```r
1 + 2
```

```
## [1] 3
```

```r
13/2
```

```
## [1] 6.5
```

```r
2^6
```

```
## [1] 64
```

```r
5 * (2 + 3)
```

```
## [1] 25
```


### Variable Assignment

Of course, R is a programming language, so it is much more powerful than a basic calculator. A major aspect of computing with R involves the assignment of values to variables. There are two (almost) equivalent ways to do this:


```r
x = 4
x <- 4
```


In both cases, `x` will represent `4` for all lines of code below these here, unless you reassign `x`.


```r
x
```

```
## [1] 4
```

```r
x + 2
```

```
## [1] 6
```

```r
x = 8
x
```

```
## [1] 8
```


It is important not to confuse variable assignment with a statement about equality. In your head, you should say *set x to 4* or *x gets 4*, but not *x is equal to 4*. Don't worry now about the subtle differences between the two assignment styles. Although using `=` is more consistent with the norm in other programming languages, some people prefer `<-` as it makes the action that is being performed more obvious. Whichever you choose, it's best to be consistent throughout your code.

In case you're wondering, you test for equality with two equal signs (`==`), which does something completely different:


```r
2 == 2
```

```
## [1] TRUE
```

```r
2 == 3
```

```
## [1] FALSE
```


It's fine to use variable names like `x` for simple math examples like the ones above. But, when writing code to perform analysis, you should be careful to use descriptive names. Code where things are named, `subject_id`, `condition`, and `rt` will be a bit more verbose than if you had used `x`, `y`, and `z`, but it will also make **much** more sense when you read it again 4 months later as you write up the paper.

With that said, there are a few rules for variable names. You can use any alphanumeric character, although the first character must be a letter. You can't use spaces, because the computer doesn't know that you're trying to write a phrase and interprets that as two (or more) separate terms. When you want something like a phrase, the `_` and `.` characters can be employed (this can be a bit confusing as `.` is usually meaningful in programming languages, but not in R).

Here's a simple example that novice coders often find confusion. Walk yourself through the code and make sure you understand what operations lead to the final return value:


```r
a = 10
b = 20
a = b
print(a)
```

```
## [1] 20
```


Using functions
---------------

Another core concept involves using *functions* to perform more complex operations. Functions in R work like they do in mathematics: they specify a transformation from one or more inputs (called *arguments* or *parameters*) to one or more outputs (or *return values*). You *call* a function by writing its name followed by parentheses, with any arguments going inside the parentheses. We already saw one example of this with the `print()` function above. The `cat()` function is similar, but it converts its arguments into characters first. There are also some basic mathematical functions built into R that operate on numbers:


```r
abs(-4)
```

```
## [1] 4
```

```r
sqrt(64)
```

```
## [1] 8
```

```r
log(1.75)
```

```
## [1] 0.5596
```


A frequently-used function is `c()`, which stands for *concatenate*. This takes a sequence of arguments and sticks them together into a *vector*, which we'll explain a little bit more about below. All you need to know now is that most of the built in functions for descriptive statistics (and there are many of these!) expect to receive a vector or something like it.


```r
a = c(1.5, 4, 3)
cat(a)
```

```
## 1.5 4 3
```

```r
sum(a)
```

```
## [1] 8.5
```

```r
mean(a)
```

```
## [1] 2.833
```

```r
sd(a)
```

```
## [1] 1.258
```


You can also *compose* functions, which allows for more expressive code:


```r
a = c(-2, 4, 5.5)
sum(abs(a))
```

```
## [1] 11.5
```


### Keyword Arguments

Sometimes, functions have *keyword arguments*. When values are not passed for these arguments, they take a default value, which can be found when you look at the help for that function (`help(func_name)` or `?func_name`). For example, most statistical functions in R have built-in missing-value handling. Because missing data is common with real-world data, there is a special object in R to stand for it called `NA`. Functions like `mean` have an optional argument `na.rm` which tells the function whether it should just ignore these values. It's `FALSE` by default, so a vector with missing values will have a mean of NA (to indicate that the normal mathematical procedure failed on these particular data):


```r
a = c(2, 6, NA, 8)
mean(a)
```

```
## [1] NA
```


However, you can handle the missing data by setting `na.rm` to `TRUE`, which omits any `NA` items from the calculation.


```r
mean(a, na.rm = TRUE)
```

```
## [1] 5.333
```


You'll find abundant use of keyword arguments as we move onto functions encapsulating more complex statistical methods.

Common Data Structures
---------------------

Although it's nice to be able to do basic arithmetic on numbers, for data analysis you're usually going to have a *dataset*. Fortunately, R has several higher-level data structures that can represent collections of data along with semantic information describing the elements of those data sets.

### Vectors

We've already seen one of the most basic data structures, which is called a *vector*. Vectors are an ordered group of elements with a single dimension. This is what you get by using the `c()` function:


```r
c(1, 2, 3, 4, 5, 6)
```

```
## [1] 1 2 3 4 5 6
```


A shortcut to get an equivalent sequence uses the `:` operator:


```r
1:6
```

```
## [1] 1 2 3 4 5 6
```


You can also associate a name with each element in the vector:


```r
c(foo = 1, bar = 2)
```

```
## foo bar 
##   1   2
```


or add names to an existing vector:


```r
v = 1:3
names(v) = c("foo", "bar", "buz")
v
```

```
## foo bar buz 
##   1   2   3
```


To pull specific elements out of a vector, you *index* (or *subscript*) by writing the name of the vector and then adding square brackets (`[ ]`)  with the position of the item you want (starting at 1). You can also use `:` to index multiple elements:


```r
v = 1:6
v[3]
```

```
## [1] 3
```

```r
v[3:6]
```

```
## [1] 3 4 5 6
```


If your vector has names associated associated with the values, you can index with those too:


```r
v = 1:3
names(v) = c("foo", "bar", "buz")
v["bar"]
```

```
## bar 
##   2
```


Indexing into a vector allows you not just to use the value in that position, but to change it too:


```r
v[1:2] = c(4, 5)
v["buz"] = 6
v
```

```
## foo bar buz 
##   4   5   6
```


An important fact about vectors is that all of the elements in the vector have to be the same datatype. For the most part, there are three datatypes you should care about:

- logical (`TRUE`, `FALSE`)
- numeric
- character

These are listed in increasing order of generality, since logical data can be considered numeric (with `FALSE == 0` and `TRUE == 1`) and numbers can be encoded as strings. When a vector is created with multiple datatypes, the most general one is chosen. Be aware that this can cause unexpected errors:


```r
v = c(TRUE, 1, "1")
v
```

```
## [1] "TRUE" "1"    "1"
```

```r
v[3] + 2
```

```
## Error: non-numeric argument to binary operator
```


There are some functions to convert vectors between types:


```r
v = c(1, 0, 1)
as.logical(v)
```

```
## [1]  TRUE FALSE  TRUE
```

```r
as.character(v)
```

```
## [1] "1" "0" "1"
```

```r
as.numeric(c("1", 2.5))
```

```
## [1] 1.0 2.5
```


While we're talking about datatypes, we'll point out that the terms "character" and "string" are interchangeable (although the R functions use the former term), and you can use either `'` or `"` to create strings. Additionally, R does not care too much about the distinction between integers and floating point numbers, and in fact most things are floats behind the scenes unless you go out of your way to force integer representation.

One nice thing about vectors is that you can treat vectors as whole objects in mathematical expressions, and the expression will be applied to the entire vector (this is called "vectorized computation"). This results in code that is both easier to read and faster to execute than performing the operation on each element of the vector:


```r
v = c(4, -2.5, 6, -7.3)
v * 0.5
```

```
## [1]  2.00 -1.25  3.00 -3.65
```

```r
v^2
```

```
## [1] 16.00  6.25 36.00 53.29
```

```r
abs(v)
```

```
## [1] 4.0 2.5 6.0 7.3
```

```r
w = 1:4
log(w)
```

```
## [1] 0.0000 0.6931 1.0986 1.3863
```

```r
v + w
```

```
## [1]  5.0 -0.5  9.0 -3.3
```


### Matrices

Matrices are a lot like vectors, except they have two dimensions. You can create them in a few ways. The `matrix` function takes a vector and reshapes it into a matrix based on the other arguments:


```r
v = 1:6
matrix(v, nrow = 2)
```

```
##      [,1] [,2] [,3]
## [1,]    1    3    5
## [2,]    2    4    6
```

```r
matrix(v, ncol = 3)
```

```
##      [,1] [,2] [,3]
## [1,]    1    3    5
## [2,]    2    4    6
```

```r
matrix(v, nrow = 2, byrow = TRUE)
```

```
##      [,1] [,2] [,3]
## [1,]    1    2    3
## [2,]    4    5    6
```


You can also glue several vectors together into a matrix either along rows or along columns:


```r
v_1 = 1:6
v_2 = 7:12
rbind(v_1, v_2)
```

```
##     [,1] [,2] [,3] [,4] [,5] [,6]
## v_1    1    2    3    4    5    6
## v_2    7    8    9   10   11   12
```

```r
cbind(v_1, v_2)
```

```
##      v_1 v_2
## [1,]   1   7
## [2,]   2   8
## [3,]   3   9
## [4,]   4  10
## [5,]   5  11
## [6,]   6  12
```


Matrix elements can also have names. As you see above, the `rbind` and `cbind` functions set the names of the rows/columns to the variable names that were passed into them. Alternatively, the `rownames` and `colnames` functions can be used much like the `names` function for vectors:


```r
m = matrix(1:6, nrow = 2)
rownames(m) = c("a", "b")
colnames(m) = c("x", "y", "z")
m
```

```
##   x y z
## a 1 3 5
## b 2 4 6
```


Some functions can compute descriptive statistics to collapse one of the dimensions in the matrix and return a vector:


```r
rowMeans(m)
```

```
## a b 
## 3 4
```

```r
colSums(m)
```

```
##  x  y  z 
##  3  7 11
```


You can also index into a matrix to expose either a single element or an entire row/column:


```r
m[1, 2]
```

```
## [1] 3
```

```r
m[1, ]
```

```
## x y z 
## 1 3 5
```

```r
m[, 3]
```

```
## a b 
## 5 6
```

```r
m["a", "z"]
```

```
## [1] 5
```

```r
m["b", ]
```

```
## x y z 
## 2 4 6
```

```r
m[, "y"]
```

```
## a b 
## 3 4
```

```r
m["a", ]["x"]
```

```
## x 
## 1
```


The rules about datatypes also apply to matrices.

### Lists

A `list` is also a lot like a vector, except each element can be a different datatype. Although names aren't strictly necessary for lists, in almost all cases you'll want to use them. You can access specific elements of a list by writing the name of the list, then the `$` character, followed by the name of the element you want.



```r
l = list(foo = "a", bar = 1)
l
```

```
## $foo
## [1] "a"
## 
## $bar
## [1] 1
```

```r
l$foo
```

```
## [1] "a"
```

```r
is.numeric(l$bar)
```

```
## [1] TRUE
```


### DataFrames

Possibly the most useful data structure, and the one you'll encounter most often when doing statistics with R, is the `data.frame`. Technically, a dataframe is a list of vectors, although you don't need to interact directly with lists to use them. You can make a dataframe with the eponymous function, which creates a two-dimensional object (like a matrix) with each component vector placed in the columns. In this sense, it's similar to a basic spreadsheet in Excel or SPSS, which you may have experience with:


```r
df = data.frame(foo = 1:6, bar = rep(c("a", "b"), 3))
df
```

```
##   foo bar
## 1   1   a
## 2   2   b
## 3   3   a
## 4   4   b
## 5   5   a
## 6   6   b
```

```r
df$foo
```

```
## [1] 1 2 3 4 5 6
```


Once you have a dataframe, you can also add more fields to it:


```r
df$buz = exp(df$foo)
df
```

```
##   foo bar     buz
## 1   1   a   2.718
## 2   2   b   7.389
## 3   3   a  20.086
## 4   4   b  54.598
## 5   5   a 148.413
## 6   6   b 403.429
```


### An interlude on R data

Although it's possible to create a dataframe from scratch (as demonstrated above) in most cases you'll be reading data into R that was created elsewhere. It's useful at this point to introduce two concepts that govern how R thinks about accessing data. When dealing with data that are saved in a file somewhere on your computer, R has the concept of the *working directory*. Any functions that read or write files to or from the disk will take as an argument a filename, and the filename you give should be a path relative to your working directory. You can change the working directory either by calling the `setwd()` function or by using the GUI tools in the R or RStudio apps.

Assigning some value to a variable creates a new object in the *workspace*, which you can think of as R's "working memory." Any object in the workspace can be immediately referenced in a line of code. You can open a pane in RStudio that will show you the name of every object in your workspace along with some information about those objects, and you can also get a vector of these names with the `ls()` function. To remove an object from your workspace, use the `rm()` function.

### More on DataFrames

Let's load in one of the data files we'll be using as exercises for this class. Most of the data we'll be using is in *csv* format, which stands for "comma separated values." This is a plain-text format where commas divide columns and rows are placed on new lines. Because the data are stored as plain text, you can view (and edit) them in a basic text editor. The csv format is also advantageous relative to proprietary binary formats (like `.xlsx` or `.mat`) because pretty much any statistical application will contain routines to read and write these files.

The example dataset is stored in the file `earlydeaths.csv`. In this dataset, each juvenile death in the County (*n* = 350) is labeled by the year it occurred (`time` = 1, 2 or 3; corresponding to 1990-91, 1992-93, 1994-95), and by the cause of death (`cause` = ‘maltreatment’ or ‘other’).  **Is the cause of death changing over time?**

Now, let's load in the data:


```r
df_death = read.csv("earlydeaths.csv")
```


When you load in a dataset, you'll want to explore it a bit so you get a feel for the kind of data it contains (and to ensure that it was loaded properly). Some of the functions you'll find yourself using for this purpose are `str()`, `head()`, and `summary()`. These all do somewhat different things, which you can likely deduce from their output and help files:


```r
str(df_death)
```

```
## 'data.frame':	350 obs. of  2 variables:
##  $ time : int  1 1 1 1 1 1 1 1 1 1 ...
##  $ cause: Factor w/ 2 levels "maltreat","other": 1 1 1 1 1 1 1 1 1 1 ...
```

```r
head(df_death)
```

```
##   time    cause
## 1    1 maltreat
## 2    1 maltreat
## 3    1 maltreat
## 4    1 maltreat
## 5    1 maltreat
## 6    1 maltreat
```

```r
summary(df_death)
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


R has a number of *generic* functions like `summary()` that will behave differently depending on the type of object you called them on. As we see above asking for a summary of a dataframe will report some quantile and count information. You'll use `summary()` a lot, though, and it will sometimes behave very differently. For example, you can call `table()` on two dataframe fields to compute a contingency table (or crosstab) of those data:


```r
death_table = table(df_death$time, df_death$cause)
death_table
```

```
##    
##     maltreat other
##   1       26    68
##   2       31    80
##   3       45   100
```


Calling `summary()` on this object actually performs a $\chi^2$ test on this contingency table!


```r
summary(death_table)
```

```
## Number of cases in table: 350 
## Number of factors: 2 
## Test for independence of all factors:
## 	Chisq = 0.4, df = 2, p-value = 0.8
```


This basic pattern (using a generic function to perform different kinds of processing depending on the type of object you're operating over) can be a bit confusing, but it is central to R's power and agility as a data analysis environment.
