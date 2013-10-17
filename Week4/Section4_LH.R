# Section 4

## Announcements
## Quiz 2: Moved to 10/25, HW3: Moved to 10/23

#### Discuss common errors. ###############

## Multiple regression models app
## How do we compare models in R?

## Quick probability exercise:
## In 10 tosses of a fair coin, what is the probability of getting 
## between 3 and 6 Heads (inclusive)? 

P(3 ≤ r ≤ 6) 
P(2.5 < r < 6.5)

## Continuity correction factor!

# A continuity correction factor is used when you use a continuous function 
# to approximate a discrete one; when you use a normal distribution table to 
# approximate a binomial, you’re going to have to use a continuity correction factor. 
# Adding or subtracting .5
# Refer to https://people.richland.edu/james/lecture/m170/ch07-bin.html

Continuity Correction Factor
# If   P(X=n) use   P(n – 0.5 < X < n + 0.5)
P(2.5 < r < 6.5)

# Now convert r = 2.5 into a z-score, and do the same for r = 6.5. 
# To do that, we need the mean, np = 10(.5) =5
# and the variance, npq = 10(.5)(.5) = 2.5. 
# So σ = 2.5 = 1.58. 
# For r = 2.5, Z = (2.5 - 5)/1.58 = -1.58. 
# For r = 6.5, Z = Z = (6.5 - 5)/1.58 = 0.95. 
# Thus P(3 ≤ r ≤ 6) = P(2.5 < r < 6.5) = P(-1.58 < Z < 0.95) = 

pnorm(-1.58, lower.tail=TRUE) -> p1
pnorm(.95, lower.tail=FALSE) -> p2
1-p1-p2
                                                                                                      (6.5 - 5)/1.58 = 0.95. Thus P(3 ≤ r ≤ 6) = P(2.5 < r < 6.5) = P(-1.58 < Z < 0.95) = ... = .772.)
pbinom(6.5,10,.5) - pbinom(2.5,10,.5)

# Calculate P(1 < \chi_3^2 < 6.25)

p1 = pchisq(6.25, df = 3, lower.tail=F)
p2 = pchisq(1, df = 3, lower.tail = T)
1-p2-p1
 
# Problem 1
In a random sample of 100 teenagers, measurements were made of:
number of stressful life events they had to deal with in the preceding year (E = event), 
their social coping skills (C = coping), 
and their depression scores (D = depress). 

Let us focus on the possible influence of event on depress. A partial summary of 
the data follows. 
                                                                                                                     depress). Let us focus on the possible influence of event on depress. A partial summary of the data follows. 
## A
# Begin by inputing the given values.
Dbar <- 3.8
Ebar <- 3
SS_D <- 401.1
SS_E <- 134.4
SP <- 55.2
n=100 # Where is n given?

### a) Correlation between D and E, r_DE. Test r_DE.
# To answer the first part, we need to know that r_DE = SP_DE/sqrt(SS_D*SS_E). Thus,
s_D <- sqrt(SS_D/(n-1))
s_E <- sqrt(SS_E/(n-1))

r <- SP/(s_D*s_E*(n-1))
print(r)

# alternatively and simpler
r <- SP/(sqrt(SS_E*SS_D))
print(r)

# For the second part we should use the formula t=r*sqrt((n-2)/(1-r^2)). So we get the t first and then test it.

t <- r*sqrt((n-2)/(1-r^2))
print(t)

p <- pt(t,n-2, lower.tail=F) 
print(p)
# r= .24 and p<.01. So the number of stressful events correlates with depression scores.

### b) Can the number of events predict depression scores?
# Now we need to know that a = Dbar - b*Ebar and b = SP/SS_E
y~a+bx
D~a+b(E)

b <- SP/SS_E
a <- Dbar - b*Ebar
print(a)
print(b)
# So D = 2.58 + .41E

### c) Compute the standard error of predicted D. Let's call this Y. We need to know that 
## s.e._Y = sqrt(SS_res/n-2) and SS_res = SS_D*(1-r^2) in this case. So,

SS_res <- SS_D*(1-r^2)
s.e._Y <- sqrt(SS_res/(n-2))

print(s.e._Y)
# s.e._Y = 1.97

### d) 95% (conf_95) confidence interval of a predicted value. Let's name the 
# predicted value yhat and recall that the 95% confidence interval will be given by 
# yhat+- t(alpha)s.e._Y. Consequently,
score <- 5
yhat <- a+b*score

t = qt(.025, n-2, lower.tail = F)
t #[1] 1.984467

conf_95low <- yhat-t*s.e._Y
conf_95high <- yhat+t*s.e._Y
print(conf_95low)
print(conf_95high)
# The 95% conf interval of this predicted value is (.73, 8.51). 
# This is NOT the 95% conf interval of b!

### e) Use additional correlational info and describe the "mechanisms" not the data.
# It would be useful to know if these other correlations are significant. So let's test them. 
r_DC <- -.197
r_EC <- .247

t_r_DC <- r_DC*sqrt((n-2)/(1-r_DC^2))
p_t_r_DC <- pt(t_r_DC, n-2, lower.tail=T)
print(t_r_DC)
print(p_t_r_DC)

t_r_EC <- r_EC*sqrt((n-2)/(1-r_EC^2))
p_t_r_EC <- pt(t_r_EC, n-2, lower.tail=F)
print(t_r_EC)
print(p_t_r_EC)

# We have a bunch of interesting relationships. Describing relationships in HW



