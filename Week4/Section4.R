# Section 4
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

# alternatively and simpler
r <- SP/(sqrt(SS_E*SS_D))

# For the second part we should use the formula t=r*sqrt((n-2)/(1-r^2)). So we get the t first and then test it.

t <- r*sqrt((n-2)/(1-r^2))
p <- pt(t,n-2, lower.tail=F) 
# r= .24 and p<.01. So the number of stressful events correlates with depression scores.

### b) Can the number of events predict depression scores?
# Now we need to know that a = Dbar - b*Ebar and b = SP/SS_E
b <- SP/SS_E
a <- Dbar - b*Ebar
# So D = 2.58 + .41E

### c) Compute the standard error of predicted D. Let's call this Y. We need to know that s.e._Y = sqrt(SS_res/n-2) and SS_res = SS_D*(1-r^2) in this case. So,

SS_res <- SS_D*(1-r^2)
s.e._Y <- sqrt(SS_res/(n-2))

# s.e._Y = 1.97

### d) 95% (conf_95) confidence interval of a predicted value. Let's name the predicted value yhat and recall that the 95% confidence interval will be given by yhat+- 1.96s.e._Y. Consequently,
score <- 5
yhat <- a+b*score

t = qt(.025, 98, lower.tail = F)
t #[1] 1.984467

conf_95low <- yhat-t*s.e._Y
conf_95high <- yhat+t*s.e._Y
# The 95% conf interval of this predicted value is (.73, 8.51). This is NOT the 95% conf interval of b!

# A more precise way to compute it relies on adjusting for how far from the mean the predictor is. In this case we adjust s.e._Y by sqrt(1 + (1/N) + (((x - Ebar)^2)/((n - 1)*(SS_X/(n - 2))))). So:

adj_s.e._Y = s.e._Y*sqrt(1 + (1/n) + (((5 - Ebar)^2)/((n - 1)*(SS_E/(n - 2)))))
# Note that this increased our standard error of the prediction. So we expect the new 95% confidence interval to be wider.
adj_conf_95low <- yhat-t*adj_s.e._Y
adj_conf_95high <- yhat+t*adj_s.e._Y
# Adjusted 95% confidence interval (.65, 8.6). Given the small difference you are welcomed to use the non adjusted s.e._Y.

### e) Use additional correlational info and describe the "mechanisms" not the data. See figure on HW PDF.
# It would be useful to know if these other correlations are significant. So let's test them. 
r_DC <- -.197
r_EC <- .247

t_r_DC <- r_DC*sqrt((n-2)/(1-r_DC^2))
p_t_r_DC <- pt(t_r_DC, n-2, lower.tail=T)

t_r_EC <- r_EC*sqrt((n-2)/(1-r_EC^2))
p_t_r_EC <- pt(t_r_EC, n-2, lower.tail=F)

# We have a bunch of interesting relationships. Note the potentially quadratic relationship of coping on event. What could this mean? What is the implication of the negative relationship between depress and coping?

## E
### E.1.a)
# A group of patients with chest pain thought to be anginal were studied by a maximal exercise treadmill test (a positive test is thought to indicate coronary artery disease).  The gender of each patient was recorded, and later their disease was classified into zero-, one- or multi-vessel disease (in increasing order of severity).

P_Male <- (47 + 86 + 227 + 132 + 53 + 49) / (47 + 86 + 227 + 132 + 53 + 49 + 62 + 28 + 44 + 83 + 14 + 9)
# P_Male = 0.712

# E.1.b)
# The probability of testing positive for male patients with angina was 0.61, and the probability of testing positive for female patients with angina was 0.56.

P_pos_Male <- (47 + 86 + 227) / (47 + 86 + 227 + 132 + 53 + 49)
# P_pos_Male) = 0.606

P_pos_Female <- (62 + 28 + 44) / (62 + 28 + 44 + 83 + 14 + 9)
# P_pos_Female = 0.558

# E.1.c)
# While a much higher portion of patients with angina are men than are women, the maximal exercise treadmill test returns a positive result with roughly the same frequency across gender.

# E.2) (Code below...)
# After recoding the severity level of disease into a dichotomous variable (healthy/zero vessels and diseased/one or more vessels), I used a chi-square test of independence within each gender group to evaluate how diagnostic the treadmill test is of diseased vessels.  There was a significant relationship between test result and disease for both men, X2(1,N=594) = 124.56, p < 0.001, and for women, X2(1,N=240) = 24.07, p < 0.001.  Patients (of both genders) who test positive were more likely to have coronary artery disease, which shows that the test is diagnostic.  However, for men the link between test outcome and disease severity is stronger than for women, as is shown by a number of different ways of measuring the effect size of the test.  The phi coefficient (which is identical to Cramer's V in this case because there are two levels of the test result) was greater for men (0.46) than for women (0.32).  Pearson's contingency coefficient for men (0.42) was also greater than for women (0.30).  Finally, the Yule's Q statistic for men (0.79) was greater than for women (0.61).  All these measurements of effect size show that the exercise treadmill test is more effective as a diagnostic test of coronary artery disease for men than for women.

## E ##
## E.1 ##
coronarytable = matrix(c(47,86,227, 132, 53, 49, 62, 28, 44, 83, 14, 9), byrow=T, ncol=3)
## E.1.a ##
p.male = sum(coronarytable[1:2,]) / sum(coronarytable)
## E.1.b ##
p.pos.ifmale = sum(coronarytable[1,]) / sum(coronarytable[1:2,])
p.pos.iffemale = sum(coronarytable[3,]) / sum(coronarytable[3:4,])
## E.2 ##
maletable = as.table(cbind(coronarytable[1:2,1],coronarytable[1:2,2]+coronarytable[1:2,3]))

femaletable = as.table(cbind(coronarytable[3:4,1],coronarytable[3:4,2]+coronarytable[3:4,3]))

chisq.test(maletable)
chisq_male = as.numeric(chisq.test(maletable)$statistic)

chisq.test(femaletable)
chisq_female = as.numeric(chisq.test(femaletable)$statistic)

## Effect Sizes

# phi coefficient
phi_coeff_m = sqrt(chisq_male / sum(maletable))
phi_coeff_f = sqrt(chisq_female / sum(femaletable))

# Cramer's V, which is identical to the above, in this case, because the table has two levels by two levels
V_m = sqrt((chisq_male / sum(maletable)) / min(2-1,2-1)) 

V_f = sqrt((chisq_female / sum(femaletable)) / min(2-1,2-1))
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  # Pearson's contingency coefficient
C_m = sqrt((chisq_male / sum(maletable)) / (1 + chisq_male / sum(maletable)))                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               C_f = sqrt((chisq_female / sum(femaletable)) / (1 + chisq_female / sum(femaletable)))
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  # Yule's Q Statistic AKA gamma
gamma_m = (maletable[1,1]*maletable[2,2] - maletable[1,2]*maletable[2,1]) / (maletable[1,1]*maletable[2,2] + maletable[1,2]*maletable[2,1])
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  gamma_f = (femaletable[1,1]*femaletable[2,2] - femaletable[1,2]*femaletable[2,1]) / (femaletable[1,1]*femaletable[2,2] + femaletable[1,2]*femaletable[2,1])



#### Discuss common errors on PDF. ###############


## Discuss logistic regression again if time allows: #########
setwd("~/Dropbox/Courses/Teaching/Stats 252/Week 2/Week 2-data")
d0 <- read.csv('09hw2data.csv')

rs1 = glm(complain ~ Responsible, data = d0, family = binomial, na.action = na.omit)
summary(rs1)
# this depends on the equation p(x)=(-1*(1+exp(b1+b2*x)))^-1

# Illustrative plots
respcoef = coef(rs1)["Responsible"]  
xr = seq(0, 20, .5)    # possible values of Responsible
# Now get the p(x) values given by the estimated model
yc = predict(rs1, data.frame(Responsible = xr), type = 'response')	
# plot the model estimated for the data
plot(d0$Responsible, d0$complain, type = 'p', main = 'P(Complain) vs Responsible', xlab='Responsible',ylab='P(Complain)')
lines(xr, yc)  		# plots predicted curve

# We could interpret the intercept in the usual way but 
# realizing that it reflects the probability at 0, instead 
# of a predicted value of the dependent variable. For example, 
# we see that the probability at 0 is  ~.8, so:

yc[1] # is .82 or ~.8, 

# The slope gives the steepness with which we transition between low and high probabilities. 

# Let's see it in practice:
# "plot cleaner"
plot(c(0, 20), c(0, 1), type = 'n', main = 'P(Complain) vs Responsible', xlab='Responsible',ylab='P(Complain)')  	

lines(xr, (1+exp(-1*(coef(rs1)[1]+coef(rs1)[2]*xr)))^-1) # the usual explicitly in terms of probabilities

lines(xr, (1+exp(-1*(1+coef(rs1)[2]*xr)))^-1) # changing the intrcept, we see that p(0 | a=1) < p(0 | a=1.48)

lines(xr, (1+exp(-1*(2+coef(rs1)[2]*xr)))^-1) # we see that p(0 | a=2) > p(0 | a=1.48)

lines(xr, (1+exp(-1*(coef(rs1)[1]-1*xr)))^-1) # we expect the probability of complaining to decrease faster for a stronger negative relationship.

# We can always provide an account of the results by directly 
#reading the predicted probability at a point of interest. 
# For example, the probability of complaining at an average 
# level of responsibility (10) is .5. Also, we are never fully 
# certain that someone will complain, given the range of 
# responsibility observed. 

# Alternatively, we could provide an account of the results in 
# terms of likelyhood ratios, as Bennoit discussed in class 
# (slide 23 on 11ho5 in week 4 materials).






