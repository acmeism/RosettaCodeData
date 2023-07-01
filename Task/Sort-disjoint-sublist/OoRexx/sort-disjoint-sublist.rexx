data = .array~of(7, 6, 5, 4, 3, 2, 1, 0)
-- this could be a list, array, or queue as well because of polymorphism
-- also, ooRexx arrays are 1-based, so using the alternate index set for the
-- problem.
indexes = .set~of(7, 2, 8)
call disjointSorter data, indexes

say "Sorted data is: ["data~toString("l", ", ")"]"

::routine disjointSorter
  use arg data, indexes
  temp = .array~new(indexes~items)
  -- we want to process these in a predictable order, so make an array
  tempIndexes = indexes~makearray
  -- we can't just assign things back in the same order.  The expected
  -- result requires the items be inserted back in first-to-last index
  -- order, so we need to sort the index values too
  tempIndexes~sortWith(.numberComparator~new)
  do index over tempIndexes
     temp~append(data[index])
  end
  -- sort as numbers
  temp~sortwith(.numberComparator~new)

  do i = 1 to tempIndexes~items
     data[tempIndexes[i]] = temp[i]
  end

-- a custom comparator that sorts strings as numeric values rather than
-- strings
::class numberComparator subclass comparator
::method compare
  use strict arg left, right
  -- perform the comparison on the names.  By subtracting
  -- the two and returning the sign, we give the expected
  -- results for the compares
  return (left - right)~sign
