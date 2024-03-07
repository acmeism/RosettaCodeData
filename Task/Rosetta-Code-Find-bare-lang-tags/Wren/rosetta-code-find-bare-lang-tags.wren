import "./ioutil" for FileUtil
import "./pattern" for Pattern
import "./set" for Set
import "./sort" for Sort
import "./fmt" for Fmt

var p = Pattern.new("/=/={{header/|[+0/y]}}/=/=", Pattern.start)
var bareCount = 0
var bareLang = {}
for (fileName in ["example.txt", "example2.txt", "example3.txt"]) {
    var lines = FileUtil.readLines(fileName)
    var lastHeader = "No language"
    for (line in lines) {
        line = line.trimStart()
        if (line == "") continue
        var m = p.find(line)
        if (m) {
            lastHeader = m.capsText[0]
            continue
        }
        if (line.startsWith("<lang>")) {
            bareCount = bareCount + 1
            var value = bareLang[lastHeader]
            if (value) {
                value[0] = value[0] + 1
                value[1].add(fileName)
            } else {
                bareLang[lastHeader] = [1, Set.new([fileName])]
            }
        }
    }
}
System.print("%(bareCount) bare language tags:")
for (me in bareLang) {
    var lang  = me.key
    var count = me.value[0]
    var names = me.value[1].toList
    Sort.insertion(names)
    Fmt.print(" $2d in $-11s $n", count, lang, names)
}
