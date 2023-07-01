import macros, sequtils, strformat, strutils

const Subscripts: array['0'..'9', string] = ["₀", "₁", "₂", "₃", "₄", "₅", "₆", "₇", "₈", "₉"]

# Modular integer with modulus N.
type ModInt[N: static int] = distinct int


#---------------------------------------------------------------------------------------------------
# Creation.

func initModInt[N](n: int): ModInt[N] =
  ## Create a modular integer from an integer.
  static:
    when N < 2: error "Modulus must be greater than 1."
  if n >= N: raise newException(ValueError, &"value must be in 0..{N - 1}.")
  result = ModInt[N](n)


#---------------------------------------------------------------------------------------------------
# Arithmetic operations: ModInt op ModInt, ModInt op int and int op ModInt.

func `+`*[N](a, b: ModInt[N]): ModInt[N] =
  ModInt[N]((a.int + b.int) mod N)

func `+`*[N](a: ModInt[N]; b: int): ModInt[N] =
  a + initModInt[N](b)

func `+`*[N](a: int; b: ModInt[N]): ModInt[N] =
  initModInt[N](a) + b

func `*`*[N](a, b: ModInt[N]): ModInt[N] =
  ModInt[N]((a.int * b.int) mod N)

func `*`*[N](a: ModInt[N]; b: int): ModInt[N] =
  a * initModInt[N](b)

func `*`*[N](a: int; b: ModInt[N]): ModInt[N] =
  initModInt[N](a) * b

func `^`*[N](a: ModInt[N]; n: Natural): ModInt[N] =
  var a = a
  var n = n
  result = initModInt[N](1)
  while n > 0:
    if (n and 1) != 0:
      result = result * a
    n = n shr 1
    a = a * a


#---------------------------------------------------------------------------------------------------
# Representation of a modular integer as a string.

template subscript(n: Natural): string =
  mapIt($n, Subscripts[it]).join()

func `$`(a: ModInt): string =
  &"{a.int}{subscript(a.N)})"


#---------------------------------------------------------------------------------------------------
# The function "f" defined for any modular integer, the same way it would be defined for an
# integer argument (except that such a function would be of no use as it would overflow for
# any argument different of 0 and 1).

func f(x: ModInt): ModInt = x^100 + x + 1


#———————————————————————————————————————————————————————————————————————————————————————————————————

when isMainModule:

  var x = initModInt[13](10)
  echo &"f({x}) = {x}^100 + {x} + 1 = {f(x)}."
