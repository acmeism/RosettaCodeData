import math
import strformat
import times

type Cycle {.pure.} = enum Physical, Emotional, Mental

const

  Lengths: array[Cycle, int] = [23, 28, 33]

  Quadrants = [("up and rising", "peak"),
               ("up but falling", "transition"),
               ("down and falling", "valley"),
               ("down but rising", "transition")]

  DateFormat = "YYYY-MM-dd"

#---------------------------------------------------------------------------------------------------

proc biorythms(birthDate: DateTime; targetDate: DateTime = now()) =
  ## Display biorythms data. Arguments are DateTime values.

  echo fmt"Born {birthDate.format(DateFormat)}, target date {targetDate.format(DateFormat)}"
  let days = (targetDate - birthDate).inDays
  echo "Day ", days

  for cycle, length in Lengths:

    let position = int(days mod length)
    let quadrant = int(4 * position / length)
    let percentage = round(100 * sin(2 * PI * (position / length)), 1)

    var description: string
    if percentage > 95:
      description = "peak"
    elif percentage < -95:
      description = "valley"
    elif abs(percentage) < 5:
      description = "critical transition"
    else:
      let (trend, next) = Quadrants[quadrant]
      let transition = targetDate + initDuration(days = (quadrant + 1) * length div 4 - position)
      description = fmt"{percentage}% ({trend}, next {next} {transition.format(DateFormat)})"

    echo fmt"{cycle} day {position}: {description}"

  echo ""

#---------------------------------------------------------------------------------------------------

proc biorythms(birthDate, targetDate = "") =
  ## Display biorythms data. Arguments are strings in ISO format year-month-day.
  let date = if targetDate.len == 0: now() else: targetDate.parse(DateFormat)
  biorythms(birthDate.parse(DateFormat), date)

#———————————————————————————————————————————————————————————————————————————————————————————————————

when isMainModule:

  biorythms("1943-03-09", "1972-07-11")
  biorythms("1809-01-12", "1863-11-19")
  biorythms("1809-02-12", "1863-11-19")
