import "./table" for FieldInfo, Table, Records

var fields = [
    FieldInfo.new("id", Num),
    FieldInfo.new("date", String),
    FieldInfo.new("trans", String),
    FieldInfo.new("sym", String),
    FieldInfo.new("qty", Num),
    FieldInfo.new("price", Num),
    FieldInfo.new("settled", Bool)
]

// create table
var table = Table.new("Stock_transactions", fields)

// add records
table.add([3, "2006-04-06", "SELL", "IBM"  ,  500, 53.00, true ])
table.add([1, "2006-01-05", "BUY" , "RHAT" ,  100, 35.14, true ])
table.add([4, "2006-04-05", "BUY" , "MSOFT", 1000, 72.00, false])
table.add([2, "2006-03-28", "BUY" , "IBM"  , 1000, 45.00, true ])

var colWidths = [2, 10, 4, 5, 4, 5.2, 7] // for listings

// show the table's fields
table.listFields()
System.print()

// sort the records by 'id' and show them
var sortFn = Fn.new { |s, t| s[0] < t[0] }
var records = table.sortedRecords(sortFn)
Records.list(table.fields, records, "Records for %(table.name) table:\n", colWidths)

// find a record by key
System.print("\nThe record with an id of 2 is:")
System.print(table.find(2))

// delete a record by key
table.remove(3)
System.print("\nThe record with an id of 3 will be deleted, leaving:\n")
records = table.sortedRecords(sortFn)
Records.list(table.fields, records, "Records for %(table.name) table:\n", colWidths)
