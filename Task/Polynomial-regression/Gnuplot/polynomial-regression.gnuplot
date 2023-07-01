# The polynomial approximation
f(x) = a*x**2 + b*x + c

# Initial values for parameters
a = 0.1
b = 0.1
c = 0.1

# Fit f to the following data by modifying the variables a, b, c
fit f(x) '-' via a, b, c
   0   1
   1   6
   2  17
   3  34
   4  57
   5  86
   6 121
   7 162
   8 209
   9 262
  10 321
e

print sprintf("\n --- \n Polynomial fit: %.4f x^2 + %.4f x + %.4f\n", a, b, c)
