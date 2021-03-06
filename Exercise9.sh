##------------##
## Question 1 ##
##------------##

# Load Data
data1 = read.csv(file = "ponzr1.csv", header = TRUE)

# Create null function with parameters
nullnllike <- function(p,x,y){
  B0 = p[1]
  sig = exp(p[2])
  
  expected = B0
  
  nullnll = -sum(dnorm(x=y, mean = expected, sd = sig, log = TRUE))
  return(nullnll)
}

# Create mutation function with parameters
mutnllike <- function(p,x,y){
  B0 = p[1]
  B1 = p[2]
  sig = exp(p[3])
  
  expected = B0 + B1*x
  
  mutnll = -sum(dnorm(x=y, mean = expected, sd = sig, log = TRUE))
  return(mutnll)
}

# Determine Null Hypothesis
initialnull = c(1,1,1,1,1,1,1,1,1,1)
null = data.frame(initialnull, data1[1:10,2])
colnames(null) = c("mutation", "ponzr1Counts")
nullguess = c(1,1)
fitnull = optim(par=nullguess, fn = nullnllike, x = null$mutation, y = null$ponzr1Counts)
print(fitnull)

# Determine Wt vs M124K fit
initialM124K = c(0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1)
M124K = data.frame(initialM124K, data1[1:20, 2])
colnames(M124K) = c("mutation", "ponzr1Counts")
initialguess = c(1,1,1)
fitM124K= optim(par=initialguess, fn=mutnllike, x=M124K$mutation, y=M124K$ponzr1Counts)
print(fitM124K)

D = 2*(fitnull$value-fitM124K$value)
pchisq(D, df = 1, lower.tail = FALSE)

print(fitnull$value)
print(fitM124K$value)
  
# Determintea WT vs V456D fit
initialV456D = c(0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1)
V456D = data.frame(t(rbind(initialV456D, data1[c(1:10,21:30), 2])))
colnames(V456D) = c("mutation", "ponzr1Counts")
initialguess = c(1,1,1)
fitV456D= optim(par=initialguess, fn=mutnllike, x=V456D$mutation, y=V456D$ponzr1Counts)
print(fitV456D)

D = 2*(fitnull$value-fitV456D$value)
pchisq(D, df = 1, lower.tail = FALSE)

# Determintea WT vs V456D fit
initialI213N = c(0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1)
I213N = data.frame(t(rbind(initialI213N, data1[c(1:10,31:40), 2])))
colnames(I213N) = c("mutation", "ponzr1Counts")
initialguess = c(1,1,1)
fitI213N= optim(par=initialguess, fn=mutnllike, x=I213N$mutation, y=I213N$ponzr1Counts)
print(fitI213N)

D = 2*(fitnull$value-fitI213N$value)
pchisq(D, df = 1, lower.tail = FALSE)

###Exercise9_Question2###

#Load data
setwd("~/Desktop/data-shell/Exercise9/Intro_Biocomp_ND_317_Tutorial9/")
M <- read.csv("MmarinumGrowth.csv", header=TRUE)

#Look at the plot to check it's shape. It is an exponetial growth curve.
plot(M$S, M$u, xlab = "Concentration", ylab = "Growth Rate")

#Custom Function
nllike <- function(p,S,y){
  umax=p[1]
  Ks=p[2]
  sigma=exp(p[3])
  
  expected=umax*(S/(S+Ks))
    
  
  nll <- -sum(dnorm(M$u,mean=expected,sd=sigma,log=TRUE))
  return(nll)
}


#Estimate parameters by minimizing the negative log likihood.
intialGuess <- c(100,10,0)
fit <- optim(par=intialGuess,fn=nllike,S=M$S,y=M$u)

print(fit)


###Exercise9_Question3###

setwd("~/Desktop/data-shell/Exercise9/Intro_Biocomp_ND_317_Tutorial9/")
L <- read.csv("leafDecomp.csv", header=TRUE)

#Look at the plot to check it's shape. It is an exponetial growth curve.
plot(L$Ms, L$decomp, xlab = "Soil Moisture", ylab = "Decomposition Rate")

#Custom Function 1: Constant Rate (y = Bo)
nllike1 <- function(p,x,y){
  Bo=p[1]
  sigma=exp(p[2])
  
  expected=Bo
  
  nll1 <- -sum(dnorm(x=y,mean=expected,sd=sigma,log=TRUE))
  return(nll1)
}

#Estimate parameters by minimizing the negative log likihood.
intialGuess <- c(590,1)
fit1 <- optim(par=intialGuess,fn=nllike1,x=L$Ms,y=L$decomp)

print(fit1)


#Custom Function 2: Linear Rate (y = Bo + B1*x)
nllike2 <- function(p,x,y){
  Bo=p[1]
  B1=p[2]
  sigma=exp(p[3])
  
  expected=Bo+B1*x
  
  nll2 <- -sum(dnorm(x=y,mean=expected,sd=sigma,log=TRUE))
  return(nll2)
}

#Estimate parameters by minimizing the negative log likihood.
intialGuess <- c(200,10,1)
fit2 <- optim(par=intialGuess,fn=nllike2,x=L$Ms,y=L$decomp)

print(fit2)

#Custom Function 1: Quadratic (y = Bo + B1*x + B2*(x)^2)
nllike3 <- function(p,x,y){
  Bo=p[1]
  B1=p[2]
  B2=p[3]
  sigma=exp(p[4])
  
  expected=Bo + B1*x + B2*x^2
  
  nll3 <- -sum(dnorm(x=y,mean=expected,sd=sigma,log=TRUE))
  return(nll3)
}

#Estimate parameters by minimizing the negative log likihood.
intialGuess <- c(200,10,-0.2,1)
fit3 <- optim(par=intialGuess,fn=nllike3,x=L$Ms,y=L$decomp)

print(fit3)

#Chi-squared tests

#Compare 1 vs 2
Q <-2*(fit1$value-fit2$value)
pchisq(q=Q,df=1,lower.tail=FALSE)

#Compare 2 vs 3
D <-2*(fit2$value-fit3$value)
pchisq(q=D,df=1,lower.tail=FALSE)

#Compare 1 vs 3
H <-2*(fit1$value-fit3$value)
pchisq(q=H,df=2,lower.tail=FALSE)

####According to the chisquare results, we should use a humped shaped response of decomosition to soil moisture (quadratic equation).
