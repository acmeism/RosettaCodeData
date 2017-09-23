import json

var data = parseJson("""{ "foo": 1, "bar": [10, "apples"] }""")
echo data["foo"]
echo data["bar"]

var js = %* [{"name": "John", "age": 30}, {"name": "Susan", "age": 31}]
echo js
