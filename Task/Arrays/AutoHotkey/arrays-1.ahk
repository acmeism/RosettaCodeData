myArray := Object() ; could use JSON-syntax sugar like {key: value}
myArray[1] := "foo"
myArray[2] := "bar"
MsgBox % myArray[2]

; Push a value onto the array
myArray.Insert("baz")
