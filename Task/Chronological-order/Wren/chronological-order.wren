import "./ioutil" for FileUtil
import "./str" for Str
import "./math" for Nums
import "./fmt" for Fmt

class Item {
    construct new(name, year, era) {
        _name = name
        _year = Num.fromString(year)
        _era  = era
        if (era == "BCE") _year = -_year
    }

    name { _name }
    year { _year }
    era  { _era  }

    <(other) { _year < other.year }
}

for (tbl in ["table.txt", "table2.txt", "table3.txt"]) {
    var lines = FileUtil.readLines(tbl)  // detects Windows automatically
    var items = []
    for (line in lines) {
        if (line == "") continue
        var spl = Str.splitNoEmpty(line, " ")
        var name = spl[0..-3].join(" ")
        var year = spl[-2]
        var era  = spl[-1]
        var it = Item.new(name, year, era)
        items.add(it)
    }
    items.sort()
    var maxLen = Nums.max(items.map{ |it| it.name.count })
    for (it in items) {
        Fmt.print("$-%(maxLen)s $-4d $-3s", it.name, it.year.abs, it.era)
    }
    System.print()
}
