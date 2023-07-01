import "/json" for JSON

var s = "{ \"foo\": 1, \"bar\": [ \"10\", \"apples\"] }"
var o = JSON.parse(s)
System.print(o)

o = { "blue": [1, 2], "ocean": "water" }
s = JSON.stringify(o)
System.print(s)
