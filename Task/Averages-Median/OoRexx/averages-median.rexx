call testMedian .array~of(9, 8, 7, 6, 5, 4, 3, 2, 1)
call testMedian .array~of(10, 9, 8, 7, 6, 5, 4, 3, 2, 1)
call testMedian .array~of(10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0, 0, 0, 0, .11)
call testMedian .array~of(10, 20, 30, 40, 50, -100, 4.7, -11e2)
call testMedian .array~new

::routine testMedian
  use arg numbers
  say "numbers =" numbers~toString("l", ", ")
  say "median =" median(numbers)
  say

::routine median
  use arg numbers

  if numbers~isempty then return 0
  -- make a copy so the sort does not alter the
  -- original set.  This also means this will
  -- work with lists and queues as well
  numbers = numbers~makearray

  -- sort and return the middle element
  numbers~sortWith(.numbercomparator~new)
  size = numbers~items
  say 'size='size
  if size//2=0 Then
    med=(numbers[size/2]+numbers[size/2+1])/2
  else
    med=numbers[size%2+1]
  -- this handles the odd value too
  return med


-- a custom comparator that sorts strings as numeric values rather than
-- strings
::class numberComparator subclass comparator
::method compare
  use strict arg left, right
  -- perform the comparison on the names.  By subtracting
  -- the two and returning the sign, we give the expected
  -- results for the compares
  return (left - right)~sign
