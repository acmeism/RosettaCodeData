(* number of days to go back from a certain day to get to Friday *)
fun fridayOffset Date.Mon = 3
  | fridayOffset Date.Tue = 4
  | fridayOffset Date.Wed = 5
  | fridayOffset Date.Thu = 6
  | fridayOffset Date.Fri = 0
  | fridayOffset Date.Sat = 1
  | fridayOffset Date.Sun = 2

fun nextMonth Date.Jan = Date.Feb
  | nextMonth Date.Feb = Date.Mar
  | nextMonth Date.Mar = Date.Apr
  | nextMonth Date.Apr = Date.May
  | nextMonth Date.May = Date.Jun
  | nextMonth Date.Jun = Date.Jul
  | nextMonth Date.Jul = Date.Aug
  | nextMonth Date.Aug = Date.Sep
  | nextMonth Date.Sep = Date.Oct
  | nextMonth Date.Oct = Date.Nov
  | nextMonth Date.Nov = Date.Dec
  | nextMonth Date.Dec = Date.Jan

(* making a date with the day set to 0 goes to the final day of the previous month *)
fun lastFriday month year =
  let
    val next_month = nextMonth month
    val year' = if next_month = Date.Jan then (year+1) else year
    val date = Date.date { day = 0, month=next_month, year=year', hour=0, minute=0, second=0, offset=NONE }
    val daysback = fridayOffset (Date.weekDay date)
    val date' = Date.date { day = (Date.day date) - daysback, month=month, year=year, hour=0, minute=0, second=0, offset=NONE }
  in
    date'
  end

fun lastFridays year =
  let
    val months = [Date.Jan, Date.Feb, Date.Mar, Date.Apr, Date.May, Date.Jun, Date.Jul, Date.Aug, Date.Sep, Date.Oct, Date.Nov, Date.Dec]
    val fridays = map (fn m => lastFriday m year) months
  in
    map (Date.fmt "%Y-%m-%d\n") fridays
  end

fun main () =
  let
    val year = valOf (Int.fromString (hd (CommandLine.arguments())))
  in
    app print (lastFridays year)
  end
  handle _ => (print (String.concat ["Usage: ", CommandLine.name(), " <year>\n"]))
