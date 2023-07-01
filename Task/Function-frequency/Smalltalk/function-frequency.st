bagOfCalls := Bag new.
Smalltalk allClassesDo:[:cls |
    cls instAndClassMethodsDo:[:mthd |
        bagOfCalls addAll:mthd messagesSent
    ].
].
(bagOfCalls sortedCounts to:10) do:[:assoc |
    Stdout printCR: e'method {assoc value} is called {assoc key} times.'
].
