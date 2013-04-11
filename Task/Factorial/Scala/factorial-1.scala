def factorial(n: Int)={
  var res = 1
  for(i <- 1 to n)
    res *=i
  res
}
