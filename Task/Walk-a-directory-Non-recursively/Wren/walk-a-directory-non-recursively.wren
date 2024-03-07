import "io" for Directory
import "./pattern" for Pattern

var walk = Fn.new { |dir, pattern|
    if (!Directory.exists(dir)) Fiber.abort("Directory does not exist.")
    var files = Directory.list(dir)
    return files.where { |f| pattern.isMatch(f) }
}

// get all C header files beginning with 'a' or 'b'
var p = Pattern.new("[a|b]+0^..h", Pattern.whole)
for (f in walk.call("/usr/include", p)) System.print(f)
