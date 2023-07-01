import "io" for File
import "/ioutil" for FileUtil

class Configuration {
    construct new(map) {
        _fullName       = map["fullName"]
        _favouriteFruit = map["favouriteFruit"]
        _needsPeeling   = map["needsPeeling"]
        _seedsRemoved   = map["seedsRemoved"]
        _otherFamily    = map["otherFamily"]
    }

    toString {
        return [
            "Full name       = %(_fullName)",
            "Favourite fruit = %(_favouriteFruit)",
            "Needs peeling   = %(_needsPeeling)",
            "Seeds removed   = %(_seedsRemoved)",
            "Other family    = %(_otherFamily)"
        ].join("\n")
    }
}

var commentedOut = Fn.new { |line| line.startsWith("#") || line.startsWith(";") }

var toMapEntry = Fn.new { |line|
    var ix = line.indexOf(" ")
    if (ix == -1) return MapEntry.new(line, "")
    return MapEntry.new(line[0...ix], line[ix+1..-1])
}

var fileName = "configuration.txt"
var lines = File.read(fileName).trimEnd().split(FileUtil.lineBreak)
var mapEntries = lines.map   { |line| line.trim() }.
                       where { |line| line != "" }.
                       where { |line| !commentedOut.call(line) }.
                       map   { |line| toMapEntry.call(line) }
var configurationMap = { "needsPeeling": false, "seedsRemoved": false }
for (me in mapEntries) {
    if (me.key == "FULLNAME") {
        configurationMap["fullName"] = me.value
    } else if (me.key == "FAVOURITEFRUIT") {
        configurationMap["favouriteFruit"] = me.value
    } else if (me.key == "NEEDSPEELING") {
        configurationMap["needsPeeling"] = true
    } else if (me.key == "OTHERFAMILY") {
        configurationMap["otherFamily"] = me.value.split(" , ").map { |s| s.trim() }.toList
    } else if (me.key == "SEEDSREMOVED") {
        configurationMap["seedsRemoved"] = true
    } else {
        System.print("Encountered unexpected key %(me.key)=%(me.value)")
    }
}
System.print(Configuration.new(configurationMap))
