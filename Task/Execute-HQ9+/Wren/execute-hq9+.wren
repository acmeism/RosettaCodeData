import "os" for Process

var hq9plus = Fn.new { |code|
    var acc = 0
    var sb = ""
    for (c in code) {
        if (c == "h" || c == "H") {
            sb = sb + "Hello, world!\n"
        } else if (c == "q" || c == "Q") {
            sb = sb + code + "\n"
        } else if (c == "9") {
            for (i in 99..1) {
                var s = (i > 1) ? "s" : ""
                sb = sb + "%(i) bottle%(s) of beer on the wall\n"
                sb = sb + "%(i) bottle%(s) of beer\n"
                sb = sb + "Take one down, pass it around\n"
            }
            sb = sb + "No more bottles of beer on the wall!\n"
        } else if (c == "+") {
            acc = acc + 1
        } else {
            Fiber.abort("Code contains illegal operation '%(c)'")
        }
    }
    System.print(sb)
}

var args = Process.arguments
if (args.count != 1) {
    System.print("Please pass in the HQ9+ code to be executed.")
} else {
    hq9plus.call(args[0])
}
