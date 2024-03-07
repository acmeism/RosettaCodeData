import "os" for Process
import "./table" for Table, FieldInfo, File
import "./str" for Str

var printUsage = Fn.new {
    System.print("""
Usage:
  wren Simple_database.wren cmd [categoryName]
  add     add item name and date, followed by optional category
  latest  print item with latest date, followed by optional category
  all     print all
  For instance: add "some item name", "some item date", "some category name"
  Dates should be in format: yyyy-mm-dd
""")
}

var printLatest = Fn.new { |table, a|
    if (table.isEmpty) {
        System.print("No entries in table.")
        return
    }
    var records = table.records
    records.sort { |s, t| Str.lt(s[1], t[1]) }  // sort by ascending date
    if (a.count == 1) {
        var found = false
        for (record in records[-1..0]) {
            if (record[2] == a[0]) {
                System.print(record)
                found = true
                break
            }
        }
        if (!found) System.print("There are no records for category '%(a[0])'.")
    } else System.print(records[-1])
}

var args = Process.arguments
if (!(1..4).contains(args.count)) {
    printUsage.call()
    return
}

// create a new Table object
var tableName = "Simple_database"
var table
if (Table.fileExists(tableName)) {
    table = Table.load(tableName)
} else {
    var fis = [
        FieldInfo.new("name", String),
        FieldInfo.new("date", String),
        FieldInfo.new("category", String)
    ]
    table = Table.new(tableName, fis)
}

var cmd = Str.lower(args[0])
if (cmd == "add") {
    if (args.count < 4) args.add("none")
    table.add(args[1..-1])
    table.save()
} else if (cmd == "latest") {
    printLatest.call(table, args[1..-1])
} else if (cmd == "all") {
    table.list()
} else {
    printUsage.call()
}
