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
fields.add(Field.new("name", FieldType.text, 25))
fields.add(Field.new("street", FieldType.text, 50))
fields.add(Field.new("city", FieldType.text, 15))
fields.add(Field.new("state", FieldType.text, 2))
fields.add(Field.new("zipCode", FieldType.text, 10))

// create table
var table = Table.new("Addresses", fields, 0)

// add records in unsorted order
table.addRecord("2, FSF Inc., 51 Franklin Street, Boston, MA, 02110-1301")
table.addRecord("1, The White House, The Oval Office 1600 Pennsylvania Avenue NW, Washington, DC, 20500")
table.addRecord("3, National Security Council, 1700 Pennsylvania Avenue NW, Washington, DC, 20500")

// show the table's fields
table.showFields()
System.print()
// show the table's records in sorted order
table.showRecords()

// find a record by key
System.print("\nThe record with an id of 2 is:")
System.print(table.findRecord(2))

// delete a record by key
table.removeRecord(1)
System.print("\nThe record with an id of 1 will be deleted, leaving:\n")
table.showRecords()
