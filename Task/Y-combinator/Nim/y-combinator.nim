# The following is implemented for a strict language as a Z-Combinator;
# Z-combinators differ from Y-combinators in lacking one Beta reduction of
# the extra `T` argument to the function to be recursed...

import sugar

proc fixz[T, TResult](f: ((T) -> TResult) -> ((T) -> TResult)): (T) -> TResult =
  type RecursiveFunc = object # any entity that wraps the recursion!
    recfnc: ((RecursiveFunc) -> ((T) -> TResult))
  let g = (x: RecursiveFunc) => f ((a: T) => x.recfnc(x)(a))
  g(RecursiveFunc(recfnc: g))

let facz = fixz((f: (int) -> int) =>
  ((n: int) => (if n <= 1: 1 else: n * f(n - 1))))
let fibz = fixz((f: (int) -> int) =>
  ((n: int) => (if n < 2: n else: f(n - 2) + f(n - 1))))

echo facz(10)
echo fibz(10)

# by adding some laziness, we can get a true Y-Combinator...
# note that there is no specified parmater(s) - truly fix point!...

#[
proc fixy[T](f: () -> T -> T): T =
  type RecursiveFunc = object # any entity that wraps the recursion!
    recfnc: ((RecursiveFunc) -> T)
  let g = ((x: RecursiveFunc) => f(() => x.recfnc(x)))
  g(RecursiveFunc(recfnc: g))
# ]#

# same thing using direct recursion as Nim has...
# note that this version of fix uses function recursion in its own definition;
# thus its use just means that the recursion has been "pulled" into the "fix" function,
# instead of the function that uses it...
proc fixy[T](f: () -> T -> T): T = f(() => (fixy(f)))

# these are dreadfully inefficient as they becursively build stack!...
let facy = fixy((f: () -> (int -> int)) =>
  ((n: int) => (if n <= 1: 1 else: n * f()(n - 1))))

let fiby = fixy((f: () -> (int -> int)) =>
  ((n: int) => (if n < 2: n else: f()(n - 2) + f()(n - 1))))

echo facy 10
echo fiby 10

# something that can be done with the Y-Combinator that con't be done with the Z...
# given the following Co-Inductive Stream (CIS) definition...
type CIS[T] = object
  head: T
  tail: () -> CIS[T]

# Using a double Y-Combinator recursion...
# defines a continuous stream of Fibonacci numbers; there are other simpler ways,
# this way implements recursion by using the Y-combinator, although it is
# much slower than other ways due to the many additional function calls,
# it demonstrates something that can't be done with the Z-combinator...
iterator fibsy: int {.closure.} = # two recursions...
  let fbsfnc: (CIS[(int, int)] -> CIS[(int, int)]) = # first one...
    fixy((fnc: () -> (CIS[(int,int)] -> CIS[(int,int)])) =>
      ((cis: CIS[(int,int)]) => (
        let (f,s) = cis.head;
        CIS[(int,int)](head: (s, f + s), tail: () => fnc()(cis.tail())))))
  var fbsgen: CIS[(int, int)] = # second recursion
    fixy((cis: () -> CIS[(int,int)]) => # cis is a lazy thunk used directly below!
      fbsfnc(CIS[(int,int)](head: (1,0), tail: cis)))
  while true: yield fbsgen.head[0]; fbsgen = fbsgen.tail()

let fibs = fibsy
for _ in 1 .. 20: stdout.write fibs(), " "
echo()
