Object subclass:#Amb
        instanceVariableNames:''
        classVariableNames:''
        poolDictionaries:''
        category:'Rosetta'
!
Smalltalk::Notification subclass:#FoundSolution
        instanceVariableNames:''
        classVariableNames:''
        poolDictionaries:''
        privateIn:Amb
!

!Amb::FoundSolution methods!

defaultAction
    ^ parameter
! !

!Amb class methods!

try:values in:aBlock
    values do:[:each |
        |rslt|
        (rslt := aBlock value:each) notNil ifTrue:[
            "hint: Notifications simply return nil, if there is no handler"
            (FoundSolution raiseRequestWith:rslt) notNil ifTrue:[ ^ rslt ].
        ].
    ].
    ^ nil
! !
