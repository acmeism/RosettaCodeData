import "./dynamic" for Enum, Tuple
import "./fmt" for Fmt
import "./sort" for Cmp, Sort

var FieldType = Enum.create("FieldType", ["text", "num", "int", "bool"])

var Field = Tuple.create("Field", ["name", "fieldType", "maxLen"])

class Table {
    construct new(name, fields, keyIndex) {
        _name = name
        _fields = fields
        _keyIndex = keyIndex // the zero based index of the field to sort on
        _records = []
        _fmt = ""
        for (f in _fields) {
            var c = f.name.count
            var l = f.maxLen.max(c)
            if (f.fieldType == FieldType.text ||f.fieldType == FieldType.bool) {
                l = -l
            }
            _fmt = _fmt + "$%(l)s  "
        }
        _fmt = _fmt.trimEnd()
    }

    name { _name }

    showFields() {
        System.print("Fields for %(_name) table:\n")
        Fmt.print("$-20s $4s  $s", "name", "type", "maxlen")
        System.print("-" * 33)
        for (f in _fields) {
           Fmt.print("$-20s $-4s  $d", f.name, FieldType.members[f.fieldType], f.maxLen)
        }
    }

    cmp_ { Fn.new { |r1, r2|
        return (Num.fromString(r1[_keyIndex]) - Num.fromString(r2[_keyIndex])).sign
    }}

    addRecord(record) {
        var items = record.split(", ")
        _records.add(items)
        Sort.insertion(_records, cmp_) // move new record into sorted order
    }

    showRecords() {
        System.print("Records for %(_name) table:\n")
        var h = Fmt.slwrite(_fmt, _fields.map { |f| f.name }.toList)
        System.print(h)
        System.print("-" * h.count)
        for (r in _records) {
            Fmt.lprint(_fmt, r)
        }
    }

    removeRecord(key) {
        for (i in 0..._records.count) {
            if (_records[i][_keyIndex] == key.toString) {
               _records.removeAt(i)
               return
            }
        }
    }

    findRecord(key) {
       for (i in 0..._records.count) {
            if (_records[i][_keyIndex] == key.toString) {
               return _records[i].join(", ")
            }
        }
        return null
    }
}

var fields = []
fields.add(Field.new("id", FieldType.int, 2))
fields.add(Field.new("date", FieldType.text, 10))
fields.add(Field.new("trans", FieldType.text, 4))
fields.add(Field.new("sym", FieldType.text, 5))
fields.add(Field.new("qty", FieldType.int, 4))
fields.add(Field.new("price", FieldType.num, 5))
fields.add(Field.new("settled", FieldType.bool, 5))

// create table
var table = Table.new("Stock_transactions", fields, 0)

// add records in unsorted order
table.addRecord("3, 2006-04-06, SELL, IBM, 500, 53.00, true")
table.addRecord("1, 2006-01-05, BUY, RHAT, 100, 35.14, true")
table.addRecord("4, 2006-04-05, BUY, MSOFT, 1000, 72.00, false")
table.addRecord("2, 2006-03-28, BUY, IBM, 1000, 45.00, true")

// show the table's fields
table.showFields()
System.print()
// show the table's records in sorted order
table.showRecords()

// find a record by key
System.print("\nThe record with an id of 2 is:")
System.print(table.findRecord(2))

// delete a record by key
table.removeRecord(3)
System.print("\nThe record with an id of 3 will be deleted, leaving:\n")
table.showRecords()
