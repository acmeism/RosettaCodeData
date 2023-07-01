import strutils

var
  curOut = 0
  maxOut = -1
  maxTimes = newSeq[string]()

for job in lines "mlijobs.txt":
  if "OUT" in job: inc curOut else: dec curOut
  if curOut > maxOut:
    maxOut = curOut
    maxTimes.setLen(0)
  if curOut == maxOut:
    maxTimes.add job.split[3]

echo "Maximum simultaneous license use is ", maxOut, " at the following times:"
for i in maxTimes: echo "  ", i
