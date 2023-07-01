sub1 = .array~of(1)
sub2 = .array~of(3, 4)
sub3 = .array~of(sub2, 5)
sub4 = .array~of(.array~of(.array~new))
sub5 = .array~of(.array~of(.array~of(6)))
sub6 = .array~new

-- final list construction
list = .array~of(sub1, 2, sub3, sub4, sub5, 7, 8, sub6)

-- flatten
flatlist = flattenList(list)

say "["flatlist~toString("line", ", ")"]"

::routine flattenList
  use arg list
  -- we could use a list or queue, but let's just use an array
  accumulator = .array~new

  -- now go to the recursive processing version
  call flattenSublist list, accumulator

  return accumulator

::routine flattenSublist
  use arg list, accumulator

  -- ask for the items explicitly, since this will allow
  -- us to flatten indexed collections as well
  do item over list~allItems
      -- if the object is some sort of collection, flatten this out rather
      -- than add to the accumulator
      if item~isA(.collection) then call flattenSublist item, accumulator
      else accumulator~append(item)
  end
