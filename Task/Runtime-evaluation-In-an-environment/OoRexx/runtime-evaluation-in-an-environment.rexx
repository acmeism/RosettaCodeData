say evalWithX("x**2", 2)
say evalWithX("x**2", 3.1415926)

::routine evalWithX
  use arg expression, x

  -- X now has the value of the second argument
  interpret "return" expression
