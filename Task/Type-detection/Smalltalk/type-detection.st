typeOf := [:anyObject |
    e'arg is of type {anyObject class name} and prints itself as: "{anyObject printString}"' printCR
].
typeOf value:1234.
typeOf value:1234.456.
typeOf value:(1/2).
typeOf value:(3+4i).
typeOf value:25 factorial.
typeOf value:true.
typeOf value:nil.
typeOf value:'hello world'.
typeOf value: (1 to:100).
typeOf value: (TopView new).
typeOf value: OperatingSystem. "a reference to the concrete OS"
typeOf value: Timestamp now.
typeOf value: #() class.
typeOf value: #() class class.
typeOf value: #() class new.
typeOf value: [ 1 print ].
typeOf value: thisContext.     "that is the current continuation (stack frame)"
typeOf value: #+.
typeOf value: (SmallInteger >> #+).
[ 1 / 0 ] on:Error do:[:ex | typeOf value: ex ].  "catch the exception"
[ 1 fooBar ] on:Error do:[:ex | typeOf value: ex ].
