|compress decompress|
compress := [:string |
   String streamContents:[:out |
       |count prev|

       count := 0.
       (string,'*')  "trick to avoid final run handling in loop"
          inject:nil
          into:[:prevChar :ch |
              ch ~= prevChar ifTrue:[
                  count = 0 ifFalse:[
                      count printOn:out.
                      out nextPut:prevChar.
                      count := 0.
                  ].
              ].
              count := count + 1.
              ch
          ]
   ]
].

decompress := [:string |
   String streamContents:[:out |
       string readingStreamDo:[:in |
           [in atEnd] whileFalse:[
               |n ch|
               n := Integer readFrom:in.
               ch := in next.
               out next:n put:ch.
            ]
       ]
   ].
].
