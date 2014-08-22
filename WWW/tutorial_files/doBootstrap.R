# Bootstrap scripts written by Desmond Ong (dco@stanford)
# Last updated: Aug 20, 2014
#
# Warning: not optimized (I wrote my own functions instead of using R's boot) so it mayyyy run slow.

# also see: http://www.statmethods.net/advstats/bootstrapping.html

#
# Borrowed awesome scripts from:
# Benoit Monin (bm.med, bm.bootstrapmed, bm.med.writeup) for bootstrapped mediation
#
# Current Table of Contents
#
# doBoot: used to bootstrap simple descriptive statistics
# doBootRegression: used to bootstrap statistics from regressions
# bm.med: mediation code from Benoit
# bm.bootstrapmed: bootstrapped mediation code from Benoit
# bm.med.writeup: mediation code from Benoit that includes a sample writeup!
#


# todo:
# -- add learning curve to show that bootstrap estimates are asymptoptically converging
# -- "learn to fish" section
# -- glm (logistic)
# -- mediated moderation / moderated mediation
#
# fix custom function to accept parameters, e.g. t.test(..., paired=TRUE)



# doBoot is the basic function that calculates descriptive statistics from one or two samples
# --------------------
#
# Output: Results
#
# Input:
#   x = first data vector. Feed in a VECTOR!
#   y = second data vector (not necessary if you're doing statistics on one data vector)
#   mediator = mediator data vector (if you want to do mediation)
#   whichTest = the test you want to do, as a string. If not provided, program will prompt for a test
#       Currently the tests supported are:
#           "mean" (single vector test)
#           "correlation" (correlation between two vectors, paired)
#           "difference, unpaired" (difference between two vectors, unpaired)
#           "difference, paired" (difference between two vectors, paired)
#           "cohen, unpaired" (basically unpaired difference / pooled standard dev) * not bias corrected nor accelerated
#           "cohen, paired" (basically paired difference / standard deviation) * not bias corrected nor accelerated
#           "mediation" (calculates a x-->y, x-->med-->y mediation, using Benoit's bm.bootmed code)
#               basically just feeds into Benoit's code for now.
#           "custom function": allows you to supply your own function, such that the desired statistic
#               is customFunction(x) or customFunction(x,y) if y is supplied.
#               Warning: doBoot doesn't test if you have supplied the correct number of arguments. It'll just try to call it.
#
#
#   numberOfIterations = number of bootstrapping iterations. Default is 5000
#   confidenceInterval = specifies the percentile of the CI. Default is .95
#   na.rm = remove NAs?
#

doBoot <- function(x, y=NULL, mediator=NULL, whichTest = NULL, customFunction = NULL,
                   numberOfIterations = 5000, 
                   confidenceInterval=.95, na.rm=TRUE) {
  whichTestReader <- function(whichTestNumber) {
    if (whichTestNumber == "1") "mean"
    else if (whichTestNumber == "2") "correlation"
    else if (whichTestNumber == "3") "difference, unpaired"
    else if (whichTestNumber == "4") "difference, paired"
    else if (whichTestNumber == "5") "cohen, unpaired"
    else if (whichTestNumber == "6") "cohen, paired"
    else if (whichTestNumber == "7") "mediation"
    else if (whichTestNumber == "8") "custom function"
    else if (whichTestNumber == "0") "exit"
    else {NULL; message("Error. Enter a number from 1 to 8\n")}
  }
  while(is.null(whichTest)) {
    cat("You didn't specify the statistic or test of interest. Please enter a number below:\n")
    cat("1 : mean (single vector test)\n")
    cat("2 : correlation (between two vectors)\n")
    cat("3 : difference, unpaired (between two vectors)\n")
    cat("4 : difference, paired (between two vectors)\n")
    cat("5 : cohen, unpaired (between two vectors)\n")
    cat("6 : cohen, paired (between two vectors)\n")
    cat("7 : mediation (three vectors, x, y and mediator in that order. x-->y, x-->med-->y)\n")
    cat("8 : custom function that you supply\n")
    cat("0 : Exit\n")
    whichTestNumber <- readline("Enter the test you want to do: ")
    whichTest = whichTestReader(whichTestNumber)
  }
  if(whichTest == "exit") return();
  if(whichTest == "custom function") {
    if(is.null(customFunction)) { 
      customFunctionString <- readline("Enter the function: ")
    } else {
      customFunctionString <- as.character(substitute(customFunction))  
    }
    customFunction <- tryCatch( { get(customFunctionString) },
                                error=function(cond) {
                                  message("Error: Function does not exist")
                                  message(cond)
                                  # Choose a return value in case of error
                                  return(NULL)
                                },
                                warning=function(cond) {
                                  message("Warning:")
                                  message(cond)
                                  # Choose a return value in case of warning
                                  return(NULL)
                                },finally={})
    if(is.null(customFunction)) return();
  }
  if(is.null(y)) {
    if(whichTest == "mediation" && is.null(mediator)) { message("Error: ", whichTest, " requires 3 vectors. Exiting."); return();  }
    else if(whichTest == "custom function") { }
    else if(whichTest != "mean") { message("Error: ", whichTest, " requires 2 vectors. Exiting."); return();}
  }
  
  
  results = list()
  # preallocate the final data vector
  bootstrappedVector <- numeric(numberOfIterations)
  cat("Performing bootstrap with whichTest ***", whichTest, "***\n")
  if(whichTest == "mean") {
    for (j in 1:numberOfIterations) { 
      bootstrappedVector[j] <- mean(sample(x, length(x), replace = TRUE, prob = NULL))
      printProgressBar(j,numberOfIterations)
    } # end iteration loop
  } else if(whichTest == "correlation") {
    for (j in 1:numberOfIterations) {
      sampleNumbers <- sample(1:length(x), length(x), replace = TRUE, prob = NULL)      
      bootstrappedVector[j] <- cor(x[sampleNumbers],y[sampleNumbers])
      printProgressBar(j,numberOfIterations)
    } # end iteration loop
  } else if(whichTest == "difference, unpaired") {
    bootstrappedVector2 <- numeric(numberOfIterations)
    for (j in 1:numberOfIterations) {
      bootstrappedVector[j] <- mean(sample(x, length(x), replace = TRUE, prob = NULL))
      bootstrappedVector2[j] <- mean(sample(y, length(y), replace = TRUE, prob = NULL))
      printProgressBar(j,numberOfIterations)
    } # end iteration loop
    bootstrappedVector = bootstrappedVector - bootstrappedVector2
    
  } else if(whichTest == "difference, paired") {
    if(length(y)!=length(x)) { message("Error: paired difference requires 2 vectors of equal length. Exiting.\n"); return() }
    
    for (j in 1:numberOfIterations) {
      sampleNumbers <- sample(1:length(x), length(x), replace = TRUE, prob = NULL)      
      bootstrappedVector[j] <- mean(x[sampleNumbers]-y[sampleNumbers])
      printProgressBar(j,numberOfIterations)
    } # end iteration loop
    
  } else if(whichTest == "cohen, unpaired") {
    bootstrappedVector2 <- numeric(numberOfIterations)
    bootstrappedVectorPooledSD <- numeric(numberOfIterations)
    for (j in 1:numberOfIterations) {
      sampleX <- sample(x, length(x), replace = TRUE, prob = NULL)
      sampleY <- sample(y, length(y), replace = TRUE, prob = NULL)
      bootstrappedVector[j] <- mean(sampleX)
      bootstrappedVector2[j] <- mean(sampleY)
      bootstrappedVectorPooledSD[j] <- sqrt( ((length(sampleX)-1)*var(sampleX) + 
                                                (length(sampleY)-1)*var(sampleY)) 
                                             /(length(sampleX)+length(sampleY)-2) )
      printProgressBar(j,numberOfIterations)
    } # end iteration loop
    bootstrappedVector = (bootstrappedVector - bootstrappedVector2) / bootstrappedVectorPooledSD
    
  } else if(whichTest == "cohen, paired") {
    if(length(y)!=length(x)) { message("Error: paired difference requires 2 vectors of equal length. Exiting.\n"); return() }
    
    for (j in 1:numberOfIterations) {
      sampleNumbers <- sample(1:length(x), length(x), replace = TRUE, prob = NULL)      
      bootstrappedVector[j] <- mean(x[sampleNumbers]-y[sampleNumbers])/sd(x[sampleNumbers]-y[sampleNumbers])      
      printProgressBar(j,numberOfIterations)
    } # end iteration loop
    
  } else if(whichTest == "mediation") {
    bm.bootstrapmed(x,mediator,y,iterations = numberOfIterations, alpha = 1-confidenceInterval); return
  } else if(whichTest == "custom function") {
    cat("Custom Function provided is: *** ", customFunctionString, "*** \n")
    if(is.null(y)) {
      for (j in 1:numberOfIterations) {
        bootstrappedVector[j] <- customFunction(sample(x, length(x), replace = TRUE, prob = NULL))
        printProgressBar(j,numberOfIterations)
      } # end iteration loop  
    } else {
      for (j in 1:numberOfIterations) {
        bootstrappedVector[j] <- customFunction(sample(x, length(x), replace = TRUE, prob = NULL),
                                                sample(y, length(y), replace = TRUE, prob = NULL))
        printProgressBar(j,numberOfIterations)
      } # end iteration loop
    }
    
  } else {
    message("Error: whichTest is not recognized. Exiting."); return
  }
  
  results$value = quantile(bootstrappedVector, .500, na.rm)
  results$ci.low = quantile(bootstrappedVector, .025, na.rm)
  results$ci.high = quantile(bootstrappedVector, .975, na.rm)
  cat("Results using", numberOfIterations, "iterations, and a", confidenceInterval, "CI \n")
  cat("whichTest used is: *** ", whichTest, "*** in the form: Result, [low end of CI, high end of CI]\n")
  cat(results$value, "[", results$ci.low, ",", results$ci.high, "]\n")
  return(results)
}









# doBootRegression is the function you call if you want to bootstrap regressions.
# --------------------
# Output: Results
#
# Input:
#   dataset = input dataset
#   formula = the regression formula of interest. For e.g., "y ~ x" or "y ~ x + (1|z)"
#   mixedEffects = whether your formula has mixed effects. Default FALSE.
#       If true, will use lmer, otherwise, lm. 
#       For lmer, will output only fixed effect coefficients
#       For lm, will output coefficients, and R^2
#   numberOfIterations = number of bootstrapping iterations. Default is 5000
#   confidenceInterval = specifies the percentile of the CI. Default is .95
#   na.rm = remove NAs?
#

doBootRegression <- function(dataset, formula, mixedEffects = FALSE, numberOfIterations = 5000, 
                             confidenceInterval=.95, na.rm=TRUE) {
  cat("If it throws a subscript out of bounds error, it could be because of singularities in the lm. To be fixed\n")
  results = list()
  if(mixedEffects) { 
    require(lme4)
    thisLMER <- summary(lmer(formula, data=dataset))
    numberOfCoefficients = length(fixef(thisLMER))
    bootstrappedCoefficients = matrix(ncol = numberOfIterations, nrow = numberOfCoefficients)
    results$coeff = matrix(nrow=numberOfCoefficients, ncol=3)
    rownames(results$coeff) <- names(fixef(thisLMER))
    colnames(results$coeff) <- c("Estimate", "CI.low", "CI.high")
    
    for (j in 1:numberOfIterations) {
      bootstrappedDataset <- dataset[sample(nrow(dataset), nrow(dataset), replace = TRUE, prob=NULL), ]
      thisLMER <- summary(lmer(formula, data=bootstrappedDataset))
      for (k in 1:numberOfCoefficients) {
        bootstrappedCoefficients[k,j] <- fixef(thisLMER)[k]
      }
      printProgressBar(j,numberOfIterations)
    } # end iteration loop
    
    
    cat("Mixed effects bootstrapped regression results using", numberOfIterations, "iterations, and a", confidenceInterval, "CI \n")
    cat("Results are in the form: Result, [low end of CI, high end of CI]\n")
    for (k in 1:numberOfCoefficients) {
      results$coeff[k,] <- c(quantile(bootstrappedCoefficients[k,], .500, na.rm), 
                             quantile(bootstrappedCoefficients[k,], .025, na.rm), 
                             quantile(bootstrappedCoefficients[k,], .975, na.rm))
      cat("Coefficient :", names(fixef(thisLMER))[k], 
          results$coeff[k,1], "[", results$coeff[k,2], ",", results$coeff[k,3], "]\n")
    }
    
    
    # end of lmer branch
  } else { # no mixed effects, use simple lm
    # preallocate the final data vector
    bootstrappedRSquaredVector <- numeric(numberOfIterations)
    numberOfCoefficients = nrow(summary(lm(formula, data=dataset))$coefficients)
    bootstrappedCoefficients = matrix(ncol = numberOfIterations, nrow = numberOfCoefficients)
    for (j in 1:numberOfIterations) {
      bootstrappedDataset <- dataset[sample(nrow(dataset), nrow(dataset), replace = TRUE, prob=NULL), ]
      thisLM = summary(lm(formula, data=bootstrappedDataset))
      bootstrappedRSquaredVector[j] <- thisLM$r.square  
      
      for (k in 1:numberOfCoefficients) {
        bootstrappedCoefficients[k,j] <- thisLM$coefficients[k,1]
      }
      printProgressBar(j,numberOfIterations)
    } # end iteration loop
    
    results$coeff = matrix(nrow=numberOfCoefficients, ncol=3)
    thisLM = summary(lm(formula, data=dataset))
    rownames(results$coeff) <- rownames(thisLM$coefficients)
    colnames(results$coeff) <- c("Estimate", "CI.low", "CI.high")
    results$Rsquare = c(quantile(bootstrappedRSquaredVector, .500, na.rm), 
                        quantile(bootstrappedRSquaredVector, .025, na.rm), 
                        quantile(bootstrappedRSquaredVector, .975, na.rm))
    cat("Bootstrapped regression results using", numberOfIterations, "iterations, and a", confidenceInterval, "CI \n")
    cat("Results are in the form: Result, [low end of CI, high end of CI]\n")
    cat("R squared:", results$Rsquare[1], "[", results$Rsquare[2], ",", results$Rsquare[3], "]\n")
    for (k in 1:numberOfCoefficients) {
      results$coeff[k,] <- c(quantile(bootstrappedCoefficients[k,], .500, na.rm), 
                             quantile(bootstrappedCoefficients[k,], .025, na.rm), 
                             quantile(bootstrappedCoefficients[k,], .975, na.rm))
      cat("Coefficient :", rownames(thisLM$coefficients)[k], 
          results$coeff[k,1], "[", results$coeff[k,2], ",", results$coeff[k,3], "]\n")
    }
    
  } # end of lm branch
  
  return(results)
} # end of doBootRegression function



# printProgressBar: helper function that just prints a simple progress bar to the console at every decade.
printProgressBar <- function(j,numberOfIterations) {
  if((j/numberOfIterations*100) %in% c(10,20,30,40,50,60,70,80,90,100)) {
    progressString = c('|', rep('+', (j/numberOfIterations*10)),rep(' ', (10-j/numberOfIterations*10)), '|')
    cat(progressString, (j/numberOfIterations*100), "% completed \n")
  } # end progress bar loop  
}


#### --- Benoit's scripts follow --- ####
## By Benoit Monin 2009 monin@stanford.edu
## Please let me know about any error you may find so I can fix it

## Simple mediation analysis a la Baron & Kenny (1986)
## Version 1.0
## Creates table with a, b, c, c' Sobel, Goodman, and their significance
## Based on normal distribution assumptions

## This is the "lite" version
## For a more detailed output use bm.med.writeup()

## Simply run the code below into R to begin using bm.med()

bm.med<-function(x,med,y) {
  summary(lm(y~x))$coefficients[2,1]->c;
  summary(lm(y~x))$coefficients[2,4]->sigc;
  summary(lm(med~x))$coefficients[2,1]->a;
  summary(lm(med~x))$coefficients[2,2]->sa;
  summary(lm(med~x))$coefficients[2,4]->siga;
  summary(lm(y~x+med))$coefficients[2,1]->cprime;
  summary(lm(y~x+med))$coefficients[2,4]->sigcprime;
  summary(lm(y~x+med))$coefficients[3,1]->b;
  summary(lm(y~x+med))$coefficients[3,2]->sb;
  summary(lm(y~x+med))$coefficients[3,4]->sigb;
  sobelsab<-sqrt(b^2*sa^2+a^2*sb^2+sa^2*sb^2);
  sobelz<-abs(a*b)/sobelsab;
  goodmansab<-sqrt(b^2*sa^2+a^2*sb^2-sa^2*sb^2);
  goodmanz<-abs(a*b)/goodmansab;
  round(rbind(c(c=c,"c'"=cprime,a=a,b=b,ab=a*b,Sobel=sobelz,Goodman=goodmanz),c(sigc,sigcprime,siga,sigb,NA,2*(1-pnorm(sobelz)),2*(1-pnorm(goodmanz)))),3)->output_table;
  rownames(output_table)<-c("Coeff","p val");
  print(output_table);
}

## Bootstrapping mediation based on Preacher & Hayes (2004)
## Version 2.0
## Requires bm.med()
## Includes a bias correction, but no acceleration

bm.bootstrapmed<-function(x,med,y,iterations=1000,alpha=.05) {
  as.data.frame(cbind(x,med,y))->vars;
  length(x)->N;
  bootab<-vector()
  for (i in 1:iterations) {
    sample(c(1:N),N,replace=T)->sampnums;
    lm(vars[sampnums,2]~vars[sampnums,1])$coefficients[2]->itera;
    lm(vars[sampnums,3]~vars[sampnums,2]+vars[sampnums,1])$coefficients[2]->iterb;
    (append(bootab,itera*iterb))->bootab
  }
  hist(bootab,main=paste("Bootsrapped a*b, with",iterations,"iterations"),col="red");
  bm.med(x,med,y)[1,5]->ab
  # Bias correction after Stine (1989)
  sum(bootab<=ab)/iterations->prob
  qnorm(prob)->Z0
  round(pnorm(2*Z0+qnorm(alpha/2)),3)->bcl
  round(pnorm(2*Z0+qnorm(1-alpha/2)),3)->bcu
  print("Bootstrap results:",quote=F)
  print(round(c("Mean(ab*)"=mean(bootab),"p(ab*<ab)"=prob),3))
  print("Uncorrected:",quote=F)
  print(round(quantile(bootab,c(alpha/2,1-alpha/2)),3))
  print("Bias Corrected:",quote=F)
  print(round(quantile(bootab,c(bcl,bcu)),3))
}

## By Benoit Monin 2011 monin@stanford.edu
## Please let me know about any error you may find so I can fix it

## Simple mediation analysis a la Baron & Kenny (1986)
## Version 1.0
## Creates table with a, b, c, c' Sobel, Goodman, and their significance
## Based on normal distribution assumptions
## This version includes standard errors and t's in the output table, and a write-up that can be copied and pasted into one's manuscript

bm.med.writeup<-function(x,med,y) {
  summary(lm(y~x))$coefficients[2,1]->c;
  summary(lm(y~x))$coefficients[2,2]->sc;
  summary(lm(y~x))$coefficients[2,3]->tc;
  summary(lm(y~x))$coefficients[2,4]->sigc;
  summary(lm(y~x))$df[2]->dfc;
  summary(lm(med~x))$coefficients[2,1]->a;
  summary(lm(med~x))$coefficients[2,2]->sa;
  summary(lm(med~x))$coefficients[2,3]->ta;
  summary(lm(med~x))$coefficients[2,4]->siga;
  summary(lm(med~x))$df[2]->dfa;
  summary(lm(y~x+med))$coefficients[2,1]->cprime;
  summary(lm(y~x+med))$coefficients[2,2]->scprime;
  summary(lm(y~x+med))$coefficients[2,3]->tcprime;
  summary(lm(y~x+med))$coefficients[2,4]->sigcprime;
  summary(lm(y~x+med))$df[2]->dfcprime;
  summary(lm(y~x+med))$coefficients[3,1]->b;
  summary(lm(y~x+med))$coefficients[3,2]->sb;
  summary(lm(y~x+med))$coefficients[3,3]->tb;
  summary(lm(y~x+med))$coefficients[3,4]->sigb;
  dfcprime->dfb
  sobelsab<-sqrt(b^2*sa^2+a^2*sb^2+sa^2*sb^2);
  sobelz<-abs(a*b)/sobelsab;
  goodmansab<-sqrt(b^2*sa^2+a^2*sb^2-sa^2*sb^2);
  goodmanz<-abs(a*b)/goodmansab;
  
  round(rbind(c(c=c,"c'"=cprime,a=a,b=b,ab=a*b,Sobel=sobelz,Goodman=goodmanz),c(sc,scprime,sa,sb,NA,sobelsab,goodmansab),c(tc,tcprime,ta,tb,NA,sobelz,goodmanz),c(dfc,dfcprime,dfa,dfb,NA,NA,NA),c(sigc,sigcprime,siga,sigb,NA,2*(1-pnorm(sobelz)),2*(1-pnorm(goodmanz)))),3)->output_table;
  rownames(output_table)<-c("Coeff","s.e.","t/z","df","p val");
  print(output_table,na.print="-");
  
  cat(sep="","COPY AND PASTE INTO YOUR WRITE-UP:
We conducted a mediation analysis following Baron & Kenny (1986).
First, the effect of the manipulation on the dependent variable was c=",round(c,3),",SE(c)=",round(sc,3),", t(",dfc,")=",round(tc,3),", p=",round(sigc,3),".
Second, the effect of the manipulation on the mediator was a=",round(a,3),",SE(a)=",round(sa,3),", t(",dfa,")=",round(ta,3),", p=",round(siga,3),".
Third, when both manipulation and mediator were entered in the same equation:
The mediator predicted the dependent variable,b=",round(b,3),",SE(b)=",round(sb,3),", t(",dfb,")=",round(tb,3),", p=",round(sigb,3),",
but the coefficient for the manipulation was now c'=",round(cprime,3),", SE(c')=",round(scprime,3),", t(",dfcprime,")=",round(tcprime,3),", p=",round(sigcprime,3),".
Finally, we used a Sobel test to test the reduction in the direct path, z=",round(sobelz,3),", p=",round(2*(1-pnorm(sobelz)),3),".
")
}