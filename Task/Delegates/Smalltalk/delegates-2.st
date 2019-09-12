Object
 subclass:#Delegator
 instanceVariableNames:'delegate'

delegate:something
    delegate := something

operation
    ^ delegate
        perform:#thing ifNotUnderstood:'default implementation'.
