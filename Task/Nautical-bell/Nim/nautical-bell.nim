import os, strformat, times

const
  Watches = ["First", "Middle", "Morning", "Forenoon", "Afternoon", "First dog", "Last dog", "First"]
  WatchEnds = [(0, 0), (4, 0), (8, 0), (12, 0), (16, 0), (18, 0), (20, 0), (23, 59)]
  Bells = array[1..8, string](["One", "Two", "Three", "Four", "Five", "Six", "Seven", "Eight"])
  Ding = "ding!"


proc nb(h, m: Natural) =
  var bell = (h * 60 + m) div 30 mod 8
  if bell == 0: bell = 8
  let hm = (h, m)
  var watch = 0
  while hm > WatchEnds[watch]: inc watch
  let plural = if bell == 1: ' ' else: 's'
  var dings = Ding
  for i in 2..bell:
    if i mod 2 != 0: dings.add ' '
    dings.add Ding
  echo &"{h:02d}:{m:02d} {Watches[watch]:>9} watch {Bells[bell]:>5} bell{plural}  {dings}"


proc simulateOneDay() =
  for h in 0..23:
    for m in [0, 30]:
      nb(h, m)
  nb(0, 0)


when isMainModule:

  simulateOneDay()

  while true:
    let d = getTime().utc()
    var m = d.second + (d.minute mod 30) * 60
    if m == 0:
      nb(d.hour, d.minute)
    sleep((1800 - m) * 1000)  # In milliseconds.
