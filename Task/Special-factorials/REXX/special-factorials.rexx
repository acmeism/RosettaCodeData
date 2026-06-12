/* REXX program to calculate Special factorials */

numeric digits 35

line = "superfactorials 0-9:       "
do n = 0 to 9
  line = line superfactorial(n)
end
say line

line = "hyperfactorials 0-9:       "
do n = 0 to 9
  line = line hyperfactorial(n)
end
say line

line = "alternating factorials 0-9:"
do n = 0 to 9
  line = line alternatingfactorial(n)
end
say line

line = "exponential factorials 0-4:"
do n = 0 to 4
  line = line exponentialfactorial(n)
end
say line

say "exponential factorial 5:   ",
  length(format(exponentialfactorial(5), , , 0)) "digits"

line = "inverse factorials:        "
numbers = "1 2 6 24 120 720 5040 40320 362880 3628800 119"
do i = 1 to words(numbers)
  line = line inversefactorial(word(numbers,i))
end
say line

return


superfactorial: procedure
  parse arg n
  sf = 1
  f = 1
  do k = 1 to n
    f = f * k
    sf = sf * f
  end
  return sf

hyperfactorial: procedure
  parse arg n
  hf = 1
  do k = 1 to n
    hf = hf * k ** k
  end
  return hf

alternatingfactorial: procedure
  parse arg n
  af = 0
  f = 1
  do i = 1 to n
    f = f * i
    af = af + (-1) ** (n - i) * f
  end
  return af

exponentialfactorial: procedure
  parse arg n
  ef = 1
  do i = 1 to n
    ef = i ** ef
  end
  return ef

inversefactorial: procedure
  parse arg f
  n = 1
  do i = 2 while n < f
    n = n * i
  end
  if n = f then
    if i > 2 then
      return i - 1
    else
      return 0
  else
    return "undefined"
