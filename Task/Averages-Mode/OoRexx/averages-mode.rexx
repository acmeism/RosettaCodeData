-- will work with just about any collection...
call testMode .array~of(10, 9, 8, 7, 6, 5, 4, 3, 2, 1)
call testMode .list~of(10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0, 0, 0, 0, .11)
call testMode .queue~of(30, 10, 20, 30, 40, 50, -100, 4.7, -11e2)

::routine testMode
  use arg list
  say "list =" list~makearray~toString("l", ", ")
  say "mode =" mode(list)
  say

::routine mode
  use arg list

  -- this is a good application for a bag
  -- add all of the items to the bag
  collector = .bag~new
  collector~putAll(list)
  -- now get a list of unique items
  indexes = .set~new~~putall(collector)
  count = 0    -- this is used to keep track of the maximums
  -- now see how many of each element we ended up with
  loop index over indexes
      items = collector~allat(index)
      newCount = items~items
      if newCount > count then do
          mode = items[1]
          count = newCount
      end
  end

  return mode
