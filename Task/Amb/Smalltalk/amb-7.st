tryAll:valuesCollection in:aBlock
    "try each set of values in aBlock;
     aBlock's number of args must be the number of elements in valuesCollection"

    |tryAll|

    tryAll :=
        [:valuesCollection :argsIn |
            valuesCollection isEmpty ifTrue:[
                aBlock valueWithArguments:argsIn
            ] ifFalse:[
                self try:(valuesCollection first) in:[:arg |
                    tryAll value:(valuesCollection from:2) value:argsIn,{arg} ]]].

    ^ tryAll value:valuesCollection value:#()
