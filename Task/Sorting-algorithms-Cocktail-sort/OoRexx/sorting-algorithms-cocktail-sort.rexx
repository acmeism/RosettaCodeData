/* Rexx */

placesList = .array~of( -
    "UK  London",     "US  New York"   , "US  Boston",     "US  Washington" -
  , "UK  Washington", "US  Birmingham" , "UK  Birmingham", "UK  Boston"     -
)

sortedList = cocktailSort(placesList~allItems())

lists = .array~of(placesList, sortedList)
loop ln = 1 to lists~items()
  cl = lists[ln]
  loop ct = 1 to cl~items()
    say cl[ct]
    end ct
    say
  end ln

return
exit

::routine cocktailSort
  use arg A

  Alength = A~items()
  swapped = .false
  loop label swaps until \swapped
    swapped = .false
    loop i_ = 1 to Alength - 1
      if A[i_] > A[i_ + 1] then do
        swap      = A[i_ + 1]
        A[i_ + 1] = A[i_]
        A[i_]     = swap
        swapped = .true
        end
      end i_
    if \swapped then do
      leave swaps
      end
    swapped = .false
    loop i_ = Alength - 1 to 1 by -1
      if A[i_] > A[i_ + 1] then do
        swap      = A[i_ + 1]
        A[i_ + 1] = A[i_]
        A[i_]     = swap
        swapped = .true
        end
      end i_
    end swaps

  return A
