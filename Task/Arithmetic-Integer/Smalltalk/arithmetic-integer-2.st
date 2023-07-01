|a b|
a := (Dialog request:'Enter first number:') asNumber.
b := (Dialog request:'Enter second number:') asNumber.
#( + - / * // \\ quo: rem: raisedTo: **) do:[:operator |
    |result|
    result := a perform:operator with:b.
    '%P %s %P => %P\n' printf:{a . operator . b . result} on:Transcript
].
