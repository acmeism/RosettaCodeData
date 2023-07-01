import "os" for Process
import "/date" for Date

var args = Process.arguments
if (args.count != 1) Fiber.abort("Please pass the current time in hh:mm:ss format.")
var startTime = Date.parse(args[0], Date.isoTime)
for (i in 0..1e8) {} // do something which takes a bit of time
var now = startTime.addMillisecs((System.clock * 1000).round)
Date.default = Date.isoTime + "|.|ttt"
System.print("Time now is %(now)")
