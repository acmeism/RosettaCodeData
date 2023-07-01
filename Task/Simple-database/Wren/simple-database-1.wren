/* simdb.wren */

import "os" for Process
import "/ioutil" for File, FileFlags, FileUtil
import "/trait" for Comparable
import "/iterate" for Reversed
import "/date" for Date
import "/sort" for Sort
import "/str" for Str

var fileName = "simdb.csv"

Date.default = Date.isoDate

class Item is Comparable {
    construct new(name, date, category) {
        _name = name
        _date = date
        _category = category
    }

    name     { _name }
    date     { _date }
    category { _category }

    compare(other) { _date.compare(other.date) }

    toString { "%(name), %(date.toString), %(category)" }
}

var printUsage = Fn.new {
    System.print("""
Usage:
  wren simdb.wren cmd [categoryName]
  add     add item name and date, followed by optional category
  latest  print item with latest date, followed by optional category
  all     print all
  For instance: add "some item name", "some item date", "some category name"
  Dates should be in format: yyyy-mm-dd
""")
}

var load = Fn.new {
    var db = []
    var lines = FileUtil.readLines(fileName)
    for (line in lines) {
        if (line == "") break   // end of file
        var item = line.split(", ")
        db.add(Item.new(item[0], Date.parse(item[1]), item[2]))
    }
    return db
}

var store = Fn.new { |item|
    File.openWithFlags(fileName, FileFlags.writeOnly) { |f|
        f.writeBytes("%(item)\n")
    }
}

var addItem = Fn.new { |input|
    if (input.count < 2) {
        printUsage.call()
        return
    }
    var date = Date.parse(input[1])
    var cat = (input.count == 3) ? input[2] : "none"
    store.call(Item.new(input[0], date, cat))
}

var printLatest = Fn.new { |a|
    var db = load.call()
    if (db.isEmpty) {
        System.print("No entries in database.")
        return
    }
    Sort.quick(db)  // sort by ascending date
    if (a.count == 1) {
        var found = false
        for (item in Reversed.new(db)) {
            if (item.category == a[0]) {
                System.print(item)
                found = true
                break
            }
        }
        if (!found) System.print("There are no items for category '%(a[0])'.")
    } else System.print(db[-1])
}

var printAll = Fn.new {
    var db = load.call()
    if (db.isEmpty) {
        System.print("No entries in database.")
        return
    }
    Sort.quick(db)  // sort by ascending date
    for (item in db) System.print(item)
}

var args = Process.arguments
if (!(1..4).contains(args.count)) {
    printUsage.call()
    return
}
// create file if it doesn't already exist
if (!File.exists(fileName)) {
    var f = File.create(fileName)
    f.close()
}

var cmd = Str.lower(args[0])
if (cmd == "add") {
    addItem.call(args[1..-1])
} else if (cmd == "latest") {
    printLatest.call(args[1..-1])
} else if (cmd == "all") {
    printAll.call()
} else {
    printUsage.call()
}
