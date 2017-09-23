testdata = .array~of(1, 2, 3, 4, 5, 5, 4, 3, 2, 1)

-- run with different period sizes
loop period over .array~of(3, 5)
    say "Period size =" period
    say
    movingaverage = .movingaverage~new(period)
    loop number over testdata
        average = movingaverage~addnumber(number)
        say "   Next number =" number", moving average =" average
    end
    say
end

::class movingaverage
::method init
  expose period queue sum
  use strict arg period
  sum = 0
  -- the circular queue makes this easy
  queue = .circularqueue~new(period)

-- add a number to the average set
::method addNumber
  expose queue sum
  use strict arg number
  sum += number
  -- add this to the queue
  old = queue~queue(number)
  -- if we pushed an element off the end of the queue,
  -- subtract this from our sum
  if old \= .nil then sum -= old
  -- and return the current item
  return sum / queue~items

-- extra method to retrieve current average
::method average
  expose queue sum
  -- undefined really, but just return 0
  if queue~isempty then return 0
  -- return current queue
  return sum / queue~items
