start = .array~of("Rick", "Mike", "David", "Mark")
new = map(start, .routines~reversit)
call map new, .routines~sayit


-- a function to perform an iterated callback over an array
-- using the provided function.  Returns an array containing
-- each function result
::routine map
  use strict arg array, function
  resultArray = .array~new(array~items)
  do item over array
     resultArray~append(function~call(item))
  end
  return resultArray

::routine reversit
  use arg string
  return string~reverse

::routine sayit
  use arg string
  say string
  return .true   -- called as a function, so a result is required
