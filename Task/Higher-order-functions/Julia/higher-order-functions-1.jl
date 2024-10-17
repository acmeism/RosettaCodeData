function foo(x)
  str = x("world")
  println("hello $(str)!")
end
foo(y -> "blue $y") # prints "hello blue world"
