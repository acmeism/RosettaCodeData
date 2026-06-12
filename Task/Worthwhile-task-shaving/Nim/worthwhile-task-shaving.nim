import std/[strformat, strutils]

const Shaved = [float 1, 5, 30, 60, 300, 1800, 3600, 21600, 86400]  # Time shaved off in seconds.
const Columns = ["1 SECOND", "5 SECONDS", "30 SECONDS", "1 MINUTE", "5 MINUTES",
                 "30 MINUTES", "1 HOUR", "6 HOURS", "1 DAY"]
const
  Diy = 365.25
  Minute = 60
  Hour = Minute * 60
  Day = Hour * 24
  Week = Day * 7
  Month = Day * Diy / 12
  Year = Day * Diy

const Freqs = [50 * Diy, 5 * Diy, Diy, Diy / 7, 12, 1]  # Frequency per year.
const Mult = 5    # Multiplier for table.

proc fmtTime(t: float; interval: string): string =
  let t = t.int
  let pl = if t == 1: "" else: "S"
  result = &"{$t & ' ' & interval & pl:<12} "

echo &"""{"HOW OFTEN YOU DO THE TASK":^93}"""
stdout.write &"""{"SHAVED OFF":<12} |"""
for text in ["50/DAY", "5/DAY", "DAILY", "WEEKLY", "MONTHLY", "YEARLY"]:
  stdout.write &" {text:<12}"
echo()
echo repeat('-', 93)
for y in 0..8:
  stdout.write &"{Columns[y]:<12} | "
  for x in 0..5:
    let t = Freqs[x] * Shaved[y] * Mult
    stdout.write if t < Minute:
                   fmtTime(t, "SECOND")
                 elif t < Hour:
                   fmtTime(t / Minute, "MINUTE")
                 elif t < Day:
                   fmtTime(t / Hour, "HOUR")
                 elif t < 14 * Day:
                   fmtTime(t / Day, "DAY")
                 elif t < 9 * Week:
                   fmtTime(t / Week, "WEEK")
                 elif t < Year:
                   fmtTime(t / Month, "MONTH")
                 else:
                   repeat(' ', 13)
  echo()
