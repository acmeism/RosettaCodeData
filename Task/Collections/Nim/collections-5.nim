import tables
var l = initTable[string, int]()
l["foo"] = 12
l["bar"] = 13

var m = {"foo": 12, "bar": 13}.toTable
m["baz"] = 14
