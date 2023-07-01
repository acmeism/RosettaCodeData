someClass class >> isAbstract
    ^ true

someClass class >> new
    self isAbstract ifTrue:[
        ^ self error:'trying to instantiate an abstract class'
    ].
    ^ super new

someClass >> method1
    ^ self subclassResponsibility
