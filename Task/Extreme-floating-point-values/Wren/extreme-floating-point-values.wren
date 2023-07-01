// using pre-defined constants
var inf = Num.infinity
var negInf = -inf
var nan = Num.nan
var negZero = -0
System.print([inf, negInf, nan, negZero])
System.print([inf + inf, negInf + inf, nan * nan, negZero == 0])
System.print([inf/inf, negInf/2, nan + inf, negZero/0])
System.print()

// using values computed from other 'normal' values
var inf2 = 1 / 0
var negInf2 = -1 / 0
var nan2 = 0 / 0

// using built-in comparison operators
System.print(inf2 == inf)
System.print(negInf == negInf2)
System.print(nan == nan2)
System.print(nan == nan)
System.print()

// using object equality
System.print(Object.same(nan, nan))
System.print(Object.same(nan, nan2))
