package require json
set sample {{ "foo": 1, "bar": [10, "apples"] }}

set parsed [json::json2dict $sample]
puts $parsed
