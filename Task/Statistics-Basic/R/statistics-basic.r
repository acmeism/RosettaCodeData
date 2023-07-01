#Generate the sets
a = runif(10,min=0,max=1)
b = runif(100,min=0,max=1)
c = runif(1000,min=0,max=1)
d = runif(10000,min=0,max=1)

#Print out the set of 10 values
cat("a = ",a)

#Print out the Mean and Standard Deviations of each of the sets
cat("Mean of a : ",mean(a))
cat("Standard Deviation of a : ", sd(a))
cat("Mean of b : ",mean(b))
cat("Standard Deviation of b : ", sd(b))
cat("Mean of c : ",mean(c))
cat("Standard Deviation of c : ", sd(c))
cat("Mean of d : ",mean(d))
cat("Standard Deviation of d : ", sd(d))

#Plotting the histogram of d
hist(d)

#Following lines error out due to insufficient memory

cat("Mean of a trillion random values in the range [0,1] : ",mean(runif(10^12,min=0,max=1)))
cat("Standard Deviation of a trillion random values in the range [0,1] : ", sd(runif(10^12,min=0,max=1)))
