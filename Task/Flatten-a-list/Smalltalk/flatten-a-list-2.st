flatDo :=
    [:element :action |
        element isCollection ifTrue:[
            element do:[:el | flatDo value:el value:action]
        ] ifFalse:[
            action value:element
        ].
    ].

collection := {
                {1} . 2 . { {3 . 4} . 5 } .
                {{{}}} . {{{6}}} . 7 . 8 . {}
              }.

newColl := OrderedCollection new.
flatDo
    value:collection
    value:[:el | newColl add: el]
