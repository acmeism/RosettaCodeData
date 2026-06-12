#! /usr/bin/env stx --script
[Stdin atEnd] whileFalse:[
    |word|
  ((word := Stdin nextLine) size > 11
      and:[word includesString:'the']
    ) ifTrue:[
        Stdout nextPutLine: word
   ]
]
