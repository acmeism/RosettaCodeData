def multiply (a, b)
  a * b
end

# with type restrictions:
def multiply (a : Int32, b : Int32)
  print "(typed overload) "
  a * b
end

# proc (anonymous function)
m = ->(a : Int32, b : Int32) { a * b }

p! multiply(2, 3),
   multiply(2.0, 3.0),
   m.call(2, 3)
