import "os" for Process
import "/date" for Date

var args = Process.arguments
if (args.count != 1) {
    Fiber.abort("Please pass just the current date in yyyy-mm-dd format.")
}
var current = Date.parse(args[0])
System.print(current.format(Date.isoDate))
System.print(current.format("dddd|, |mmmm| |d|, |yyyy"))
