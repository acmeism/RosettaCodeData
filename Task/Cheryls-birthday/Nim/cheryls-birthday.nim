import tables
import sets
import strformat

type Date = tuple[month: string, day: int]

const Dates = [Date ("May", 15), ("May", 16), ("May", 19), ("June", 17), ("June", 18),
               ("July", 14), ("July", 16), ("August", 14), ("August", 15), ("August", 17)]

const

  MonthTable: Table[int, HashSet[string]] =
                static:
                  var t: Table[int, HashSet[string]]
                  for date in Dates:
                    t.mgetOrPut(date.day, initHashSet[string]()).incl(date.month)
                  t

  DayTable: Table[string, HashSet[int]] =
              static:
                var t: Table[string, HashSet[int]]
                for date in Dates:
                  t.mgetOrPut(date.month, initHashSet[int]()).incl(date.day)
                t

var possibleMonths: HashSet[string]   # Set of possible months.
var possibleDays: HashSet[int]        # Set of possible days.


# Albert: I don't know when Cheryl's birthday is, ...
# => eliminate months with a single possible day.
for month, days in DayTable.pairs:
  if days.len > 1:
    possibleMonths.incl(month)

# ... but I know that Bernard does not know too.
# => eliminate months with one day present only in this month.
for month, days in DayTable.pairs:
  for day in days:
    if MonthTable[day].len == 1:
      possibleMonths.excl(month)
echo fmt"After first Albert's sentence, possible months are {possibleMonths}."

# Bernard:  At first I don't know when Cheryl's birthday is, ...
# => eliminate days with a single possible month.
for day, months in MonthTable.pairs:
  if months.len > 1:
    possibleDays.incl(day)

# ...  but I know now.
# => eliminate days which are compatible with several months in "possibleMonths".
var impossibleDays: HashSet[int]        # Days which are eliminated by this sentence.
for day in possibleDays:
  if (MonthTable[day] * possibleMonths).len > 1:
    impossibleDays.incl(day)
possibleDays.excl(impossibleDays)
echo fmt"After Bernard's sentence, possible days are {possibleDays}."

# Albert: Then I also know when Cheryl's birthday is.
# => eliminate months which are compatible with several days in "possibleDays".
var impossibleMonths: HashSet[string]   # Months which are eliminated by this sentence.
for month in possibleMonths:
  if (DayTable[month] * possibleDays).len > 1:
    impossibleMonths.incl(month)
possibleMonths.excl(impossibleMonths)

doAssert possibleMonths.len == 1
let month = possibleMonths.pop()
echo fmt"After second Albert's sentence, remaining month is {month}..."

possibleDays = possibleDays * DayTable[month]
doAssert possibleDays.len == 1
let day = possibleDays.pop()
echo fmt"and thus remaining day is {day}."

echo ""
echo fmt"So birthday date is {month} {day}."
