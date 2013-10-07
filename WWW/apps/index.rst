Example Applications
====================

This is a collection of web apps built using `Shiny
<http://www.rstudio.com/shiny/>`_ to illustrate and help build intuitions about
some statistical concepts.

Sampling and standard error
---------------------------

`Link to app <http://spark.rstudio.com/sgagnon/sampling_and_stderr/>`_

This example demonstrates the relationship between the standard deviation of a
population, the standard deviation and standard error of the mean for a sample
drawn from that population, and the expected distribution of means that we would
obtain if we took many samples (of the same size) from the population. It is
meant to emphasize how the standard error of the mean, as calculated from the
sample statistics for a single sample, corresponds to the width of the expected
distribution of means (under normal assumptions).

Simulating t tests
------------------

`Link to app <http://spark.rstudio.com/sgagnon/ttest_simulation/>`_

This example performs 1000 one-sample t tests (with different samples from the
same distribution) and plots the resulting histograms of t statistics and p
values. It is possible to control both the true effect size (Cohen's D) and the
number of observations in a sample to show how these two parameters relate the
expected distribution of scores. When the effect size is 0, the simulation
shows what happens when the null hypothesis is true.

Simple linear regression
------------------------

`Link to app <http://spark.rstudio.com/sgagnon/simple_regression/>`_

This example demonstrates the key objective of linear regression: finding the
coefficients for a linear model that minimize the squared distance from each
observation to the prediction made by the model at the same value of x.

