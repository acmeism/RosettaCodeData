expression = "return pow(x,2) - 7"
one = evalwithx(expression, 1.2)
two = evalwithx(expression, 3.4)
see "one = " + one + nl + "two = " + two + nl

func evalwithx expr, x
     return eval(expr)
