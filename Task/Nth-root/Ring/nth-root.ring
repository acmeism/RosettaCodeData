decimals(12)
see "cube root of 5 is : " + root(3, 5, 0) + nl

func root n, a, d
y = 0 x = a / n
while fabs (x - y) > d
      y = ((n - 1)*x + a/pow(x,(n-1))) / n
      temp = x
      x = y
      y = temp
end
return x
