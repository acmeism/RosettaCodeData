myDict := Map with(
    "hello", 13,
    "world", 31,
    "!"    , 71
)

// iterating over key-value pairs:
myDict foreach( key, value,
    writeln("key = ", key, ", value = ", value)
)

// iterating over keys:
myDict keys foreach( key,
    writeln("key = ", key)
)

// iterating over values:
myDict foreach( value,
    writeln("value = ", value)
)
// or alternatively:
myDict values foreach( value,
    writeln("value = ", value)
)
