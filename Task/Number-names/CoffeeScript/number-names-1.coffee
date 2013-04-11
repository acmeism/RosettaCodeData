spell_integer = (n) ->
  tens = [null, null, "twenty", "thirty", "forty",
      "fifty", "sixty", "seventy", "eighty", "ninety"]

  small = ["zero", "one", "two", "three", "four", "five",
       "six", "seven", "eight", "nine", "ten", "eleven",
       "twelve", "thirteen", "fourteen", "fifteen",
       "sixteen", "seventeen", "eighteen", "nineteen"]

  bl = [null, null, "m", "b", "tr", "quadr",
      "quint", "sext", "sept", "oct", "non", "dec"]

  divmod = (n, d) ->
    [Math.floor(n / d), n % d]

  nonzero = (c, n) ->
    if n == 0
      ""
    else
      c + spell_integer n

  big = (e, n) ->
    if e == 0
      spell_integer n
    else if e == 1
      spell_integer(n) + " thousand"
    else
      spell_integer(n) + " " + bl[e] + "illion"

  base1000_rev = (n) ->
    # generates the value of the digits of n in base 1000
    # (i.e. 3-digit chunks), in reverse.
    chunks = []
    while n != 0
      [n, r] = divmod n, 1000
      chunks.push r
    chunks

  if n < 0
    throw Error "spell_integer: negative input"
  else if n < 20
    small[n]
  else if n < 100
    [a, b] = divmod n, 10
    tens[a] + nonzero("-", b)
  else if n < 1000
    [a, b] = divmod n, 100
    small[a] + " hundred" + nonzero(" ", b)
  else
    chunks = (big(exp, x) for x, exp in base1000_rev(n) when x)
    chunks.reverse().join ', '

# example
console.log spell_integer 1278
console.log spell_integer 1752
console.log spell_integer 2010
console.log spell_integer 4000123007913
