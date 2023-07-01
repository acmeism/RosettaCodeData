If2 class method:
when:cond1 or:cond2 ifBoth:both ifFirst:first ifSecond:scnd ifNone:none
    ^ cond1 ifTrue:[
        cond2 ifTrue:both ifFalse:first
    ] ifFalse:[
        cond2 ifTrue:scnd ifFalse:none
    ]
