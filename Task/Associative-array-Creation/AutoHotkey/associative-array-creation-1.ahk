associative_array := {key1: "value 1", "Key with spaces and non-alphanumeric characters !*+": 23}
MsgBox % associative_array["key1"]
. "`n" associative_array["Key with spaces and non-alphanumeric characters !*+"]
