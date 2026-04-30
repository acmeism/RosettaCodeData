on stoogesort(lst, i, j)
  if item j of lst < item i of lst then
    set a to item j of lst
    set b to item i of lst
    set item i of lst to a
    set item j of lst to b
  end if
  if j - i > 1 then
    set t to (j - i + 1) / 3 as integer
    stoogesort(lst, i, j - t)
    stoogesort(lst, i + t, j)
    stoogesort(lst, i, j - t)
  end if
  return lst
end stoogesort

on stooge(lst)
  return stoogesort(lst, 1, length of lst)
end stooge

set test_list to {}
repeat 20 times
  set test_list to test_list & (random number from 1 to 20)
end repeat

stooge(test_list)
