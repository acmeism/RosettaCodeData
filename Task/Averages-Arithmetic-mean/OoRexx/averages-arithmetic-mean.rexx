call testAverage .array~of(10, 9, 8, 7, 6, 5, 4, 3, 2, 1)
call testAverage .array~of(10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0, 0, 0, 0, .11)
call testAverage .array~of(10, 20, 30, 40, 50, -100, 4.7, -11e2)
call testAverage .array~new

::routine testAverage
  use arg numbers
  say "numbers =" numbers~toString("l", ", ")
  say "average =" average(numbers)
  say

::routine average
  use arg numbers
  -- return zero for an empty list
  if numbers~isempty then return 0

  sum = 0
  do number over numbers
      sum += number
  end
  return sum/numbers~items
