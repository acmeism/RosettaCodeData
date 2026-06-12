USING: arrays formatting io kernel math prettyprint sequences
strings ;
IN: rosetta-code.type-detection

GENERIC: myprint ( object -- )

M: object myprint drop "I don't know how to print this." print ;
M: string myprint "I'm a string: \"%s\"\n" printf ;
M: fixnum myprint "I'm a fixnum: " write . ;
M: array  myprint "I'm an array: { " write
    [ pprint bl ] each "}" print ;

"Hello world." myprint
{ 1 2 3 4 5 }  myprint
123            myprint
3.1415         myprint
