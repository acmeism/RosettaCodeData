Exception
    subclass: #U0
    instanceVariableNames:''
    classVariableNames:''
    poolDictionaries:''
    category:'example'.

Exception
    subclass: #U1
    instanceVariableNames:''
    classVariableNames:''
    poolDictionaries:''
    category:'example'.

Object
    subclass: #CatchMeIfYouCan
    instanceVariableNames:'bazAlreadyCalled'
    classVariableNames:''
    poolDictionaries:''
    category:'example'.

" CatchMeIfYouCan methods "

foo
    2 timesRepeat:[
        [ self bar ]
            on: U0
            do:[ 'U0 cought' printCR ]
    ]

bar
    self baz


baz
    bazAlreadyCalled isNil ifTrue:[
        bazAlreadyCalled := true.
        U0 raise
    ] ifFalse:[
        U1 raise
    ]

CatchMeIfYouCan new foo
