def count(stream; cond):
  reduce stream as $i (0; if $i|cond then .+1 else . end);

def Months: [
    "January", "February", "March", "April", "May", "June",
    "July", "August", "September", "October", "November", "December"
];

# tostring
def birthday: "\(Months[.month-1]) \(.day)";

# Input: a Birthday
def monthUniqueIn($bds):
  .month as $thisMonth
  | count( $bds[]; .month == $thisMonth) == 1;

# Input: a Birthday
def dayUniqueIn($bds):
  .day as $thisDay
  | count( $bds[]; .day == $thisDay) == 1;

# Input: a Birthday
def monthWithUniqueDayIn($bds):
  .month as $thisMonth
  | any( $bds[]; $thisMonth == .month and dayUniqueIn($bds));

def choices: [
    {month: 5, day: 15}, {month: 5, day: 16}, {month: 5, day: 19}, {month: 6, day: 17},
    {month: 6, day: 18}, {month: 7, day: 14}, {month: 7, day: 16}, {month: 8, day: 14},
    {month: 8, day: 15}, {month: 8, day: 17}
];

# Albert knows the month but doesn't know the day,
# so the month can't be unique within the choices.
def filter1:
  . as $in
  | map(select( monthUniqueIn($in) | not));

# Albert also knows that Bernard doesn't know the answer,
# so the month can't have a unique day.
def filter2:
  . as $in
  | map(select( monthWithUniqueDayIn($in) | not));

# Bernard now knows the answer,
# so the day must be unique within the remaining choices.
def filter3:
  . as $in
  | map(select( dayUniqueIn($in) ));

# Albert now knows the answer too.
# So the month must be unique within the remaining choices.
def filter4:
  . as $in
  | map(select( monthUniqueIn($in) ));

def solve:
  (choices | filter1 | filter2 | filter3 | filter4) as $bds
  | if $bds|length == 1
    then "Cheryl's birthday is \($bds[0]|birthday)."
    else "Whoops!"
    end;

solve
