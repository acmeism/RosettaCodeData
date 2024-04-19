import "./table" for Table, FieldInfo, Records

var fields = [
    FieldInfo.new("id", Num),
    FieldInfo.new("name", String),
    FieldInfo.new("street", String),
    FieldInfo.new("city", String),
    FieldInfo.new("state", String),
    FieldInfo.new("zipCode", String)
]

// create table
var table = Table.new("Addresses", fields)

// add records in unsorted order
table.addAll([
    [2, "FSF Inc.", "51 Franklin Street", "Boston", "MA", "02110-1301"],
    [1, "The White House", "The Oval Office 1600 Pennsylvania Avenue NW", "Washington", "DC", "20500"],
    [3, "National Security Council", "1700 Pennsylvania Avenue NW", "Washington", "DC", "20500"]
])

var colWidths = [2, 25, 43, 10, 2, 10] // for listings

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
table.remove(1)
System.print("\nThe record with an id of 1 will be deleted, leaving:\n")
records = table.sortedRecords(sortFn)
Records.list(table.fields, records, "Records for %(table.name) table:\n", colWidths)
