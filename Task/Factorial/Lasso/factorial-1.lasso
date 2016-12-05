define factorial(n) => {
  local(x = 1)
  with i in generateSeries(2, #n)
  do {
    #x *= #i
  }
  return #x
}
