call testAverage .array~of(10, 9, 8, 7, 6, 5, 4, 3, 2, 1)
call testAverage .array~of(10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0, 0, 0, 0, .11)
call testAverage .array~of(30, 10, 20, 30, 40, 50, -100, 4.7, -11e2)

::routine testAverage
  use arg list
  say "list =" list~toString("l", ", ")
  say "root mean square =" rootmeansquare(list)
  say

::routine rootmeansquare
  use arg numbers
  -- return zero for an empty list
  if numbers~isempty then return 0

  sum = 0
  do number over numbers
      sum += number * number
  end
  return rxcalcsqrt(sum/numbers~items)

::requires rxmath LIBRARY
