import "io" for File
import "os" for Process
import "/pattern" for Pattern
import "/set" for Bag
import "/sort" for Sort
import "/fmt" for Fmt

var args = Process.arguments
if (args.count != 1) {
    Fiber.abort("There should be exactly one argument - the file path to be analyzed")
}
var p = Pattern.new("[+1/x.+1/x](")
var source = File.read(args[0])
var matches = p.findAll(source)
var bag = Bag.new(matches.map { |m| m.captures[0].text })
var methodCalls = bag.toMap.toList
var cmp = Fn.new { |i, j| (j.value - i.value).sign }
Sort.quick(methodCalls, 0, methodCalls.count-1, cmp)
System.print("Top ten method/function calls in %(args[0]):\n")
System.print("Called  Method/Function")
System.print("------  ----------------")
for (mc in methodCalls.take(10)) {
    Fmt.print(" $2d     $s", mc.value, mc.key)
}
