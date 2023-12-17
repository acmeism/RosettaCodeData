import "io" for Directory, File, Stat
import "./crypto" for Sha1
import "./sort" for Sort

var findDuplicates = Fn.new { |dir, minSize|
    if (!Directory.exists(dir)) Fiber.abort("Directory does not exist.")
    var files = Directory.list(dir).where { |f| Stat.path("%(dir)/%(f)").size >= minSize }
    var hashMap = {}
    for (file in files) {
        var path = "%(dir)/%(file)"
        if (Stat.path(path).isDirectory) continue
        var contents = File.read(path)
        var hash = Sha1.digest(contents)
        var exists = hashMap.containsKey(hash)
        if (exists) {
            hashMap[hash].add(file)
        } else {
            hashMap[hash] = [file]
        }
    }
    var duplicates  = []
    for (key in hashMap.keys) {
        if (hashMap[key].count > 1) {
            var files = hashMap[key]
            var path = "%(dir)/%(files[0])"
            var size = Stat.path(path).size
            duplicates.add([size, files])
        }
    }
    var cmp = Fn.new { |i, j| (j[0] - i[0]).sign } // by decreasing size
    Sort.insertion(duplicates, cmp)
    System.print("The sets of duplicate files are:\n")
    for (dup in duplicates) {
        System.print("Size %(dup[0]) bytes:")
        System.print(dup[1].join("\n"))
        System.print()
    }
}

findDuplicates.call("./", 1000)
