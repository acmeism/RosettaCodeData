a = .array~new

a~append(.pair~new("06-07", "Ducks"))
a~append(.pair~new("00-01", "Avalanche"))
a~append(.pair~new("02-03", "Devils"))
a~append(.pair~new("01-02", "Red Wings"))
a~append(.pair~new("03-04", "Lightning"))
a~append(.pair~new("04-05", "lockout"))
a~append(.pair~new("05-06", "Hurricanes"))
a~append(.pair~new("99-00", "Devils"))
a~append(.pair~new("07-08", "Red Wings"))
a~append(.pair~new("08-09", "Penguins"))

b = a~copy   -- make a copy before sorting
b~sort
say "Sorted using direct comparison"
do pair over b
   say pair
end

c = a~copy
-- this uses a custom comparator instead
c~sortWith(.paircomparator~new)
say
say "Sorted using a comparator (inverted)"
do pair over c
   say pair
end

-- a name/value mapping class that directly support the sort comparisons
::class pair inherit comparable
::method init
  expose name value
  use strict arg name, value

::attribute name
::attribute value

::method string
  expose name value
  return name "=" value

-- the compareto method is a requirement brought in
-- by the
::method compareto
  expose name
  use strict arg other
  return name~compareto(other~name)

-- a comparator that shows an alternate way of sorting
::class pairComparator subclass comparator
::method compare
  use strict arg left, right
  -- perform the comparison on the names
  return -left~name~compareTo(right~name)
