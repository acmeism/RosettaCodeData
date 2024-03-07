import "io" for Directory, File
import "./pattern" for Pattern
import "./sort" for Sort

var walk // recursive function
walk = Fn.new { |dir, pattern, found|
    if (!Directory.exists(dir)) Fiber.abort("Directory %(dir) does not exist.")
    var files = Directory.list(dir)
    for (f in files) {
        var path = dir + "/%(f)"
        if (File.exists(path)) {  // it's a file not a directory
            if (pattern.isMatch(f)) found.add(f)
        } else {
            walk.call(path, pattern, found)
        }
    }
}

// get all C header files beginning with 'va' or 'vf'
var p = Pattern.new("v[a|f]+0^..h", Pattern.whole)
var found = []
walk.call("/usr/include", p, found)
Sort.quick(found)
for (f in found) System.print(f)
