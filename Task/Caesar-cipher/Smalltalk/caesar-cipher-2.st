!CharacterArray methodsFor:'encoding'!
rot:n
    ^ self class
        streamContents:[:aStream |
            self do:[:char |
                aStream nextPut:(char rot:n) ]]


!Character methodsFor:'encoding'!
rot:n
     (self isLetter) ifTrue:[
        self isLowercase ifTrue:[
            ^ 'abcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyz' at:(self-$a+1+n)
        ] ifFalse:[
            ^ 'ABCDEFGHIJKLMNOPQRSTUVWXYZABCDEFGHIJKLMNOPQRSTUVWXYZ' at:(self-$A+1+n)
        ]
    ].
    ^ self
