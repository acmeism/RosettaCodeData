"using Stream class's bulk copy method:"
Stdin copyToEndInto:Stdout.

"line wise"
[Stdin atEnd] whileFalse:[ Stdout nextPutLine:(Stdin nextLine) ].

"character wise"
[Stdin atEnd] whileFalse:[ Stdout nextPut:(Stdin next) ].

"no EOF test, but handle EOF Exception"
[
    [ Stdout nextPut:(Stdin next) ] loop.
] on: StreamError do:[]
