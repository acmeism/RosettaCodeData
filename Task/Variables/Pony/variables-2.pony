var x: I32 = 10
var y: I32 = x = 20
try
  Fact(x == 20) // x gets the new value of 20
  Fact(y == 10) // y gets the old value of x which is 10
end
