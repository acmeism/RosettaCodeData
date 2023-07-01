/* Rexx */

parse arg userInput
call runSample userInput
return
exit

-- ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
-- Compact a list of numbers by reducing ranges
compact:
procedure
--trace ?r;nop
  parse arg expanded
  nums = expanded~changestr(',', ' ')~space -- remove possible commas & clean up the string
  rezult = ''

  RANGE = 0
  FIRST = nums~word(1) -- set starting value
  loop i_ = 2 to nums~words -- each word in the string is a number to examine
    LOCAL = nums~word(i_)
    if LOCAL - FIRST - RANGE == 1 then do
      -- inside a range
      RANGE += 1
      end
    else do
      -- not inside a range
      if RANGE \= 0 then do
        -- we have a range of numbers so collect this and reset
        rezult = rezult || FIRST || delim(RANGE) || FIRST + RANGE || ','
        RANGE = 0
        end
      else do
        -- just collect this number
        rezult = rezult || FIRST || ','
        end
      FIRST = LOCAL -- bump new starting value
      end
    end i_
  if RANGE \= 0 then do
    -- collect terminating value (a range)
    rezult = rezult || FIRST || delim(RANGE) || FIRST + RANGE
    end
  else do
    -- collect terminating value (a single number)
    rezult = rezult || FIRST
    end

  return rezult~space(1, ',') -- format and return result string

-- ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
-- determine if the range delimiter should be a comma or dash
delim:
procedure
  parse arg range .
  if range == 1 then dlm = ','
  else               dlm = '-'
  return dlm

-- ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
-- sample driver
runSample:
procedure
parse arg userInput
td. = 0
if userInput~words > 0 then do
  td.0 += 1; r_ = td.0; td.r_ = userInput
  end
else do
  td.0 += 1; r_ = td.0; td.r_ = '-6 -3 -2 -1 0 1 3 4 5 7 8 9 10 11 14 15 17 18 19 20'
  td.0 += 1; r_ = td.0; td.r_ = '0,  1,  2,  4,  6,  7,  8, 11, 12, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 27, 28, 29, 30, 31, 32, 33, 35, 36, 37, 38, 39'
  td.0 += 1; r_ = td.0; td.r_ = '-4, -3, -2, 0, 1, 2, 4, 6, 7, 8, 11, 12, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 27, 28, 29, 30, 31, 32, 33, 35, 36, 37, 38, 39'
  end

loop r_ = 1 to td.0
  say 'Original: ' td.r_~changestr(',', ' ')~space(1, ',')
  say 'Compacted:' compact(td.r_)
  say
  end r_
return
