list = '-6,-3--1,3-5,7-11,14,15,17-20'
expanded = expandRanges(list)

say "Original list: ["list"]"
say "Expanded list: ["expanded~tostring("l", ",")"]"

-- expand a string expression a range of numbers into a list
-- of values for the range.  This returns an array
::routine expandRanges
  use strict arg list
  values = list~makearray(',')
  -- build this up using an array first.  Make this at least the
  -- size of the original value set.
  expanded = .array~new(values~items)

  -- now process each element in the range
  loop element over values
      -- if this is a valid number, it's not a range, so add it directly
      if element~datatype('whole') then expanded~append(element)
      else do
          -- search for the divider, starting from the second position
          -- to allow for the starting value to be a minus sign.
          split = element~pos('-', 2)
          parse var element start =(split) +1 finish
          loop i = start to finish
              expanded~append(i)
          end
      end
  end
  return expanded
