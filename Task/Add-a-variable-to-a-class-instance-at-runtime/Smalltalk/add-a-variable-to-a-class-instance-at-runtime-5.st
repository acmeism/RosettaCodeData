Object subclass: #Monkey
  instanceVariableNames: 'aVar'
  classVariableNames: ''
  poolDictionaries: ''
  category: nil !

!Monkey class methodsFor: 'new instance'!
new
  | o |
  o := super new.
  o init.
  ^o
!!

!Monkey methodsFor: 'init instance'!
init
  aVar := 0
!
initWith: value
  aVar := value
!!

!Monkey methodsFor: 'set/get the inst var(s)'!
setVar: var
  aVar := var
!
getVar
  ^aVar
!!


"Create a new instance"
Smalltalk at: #aMonkey put: (Monkey new) !

"set the 'original' instance var to 12"
aMonkey setVar: 12 .

"let's see what's inside"
aMonkey inspect .

"add a new instance var"
Monkey addInstVarName: 'x'.

"let's see what's inside now"
aMonkey inspect .

"let us create a new method for x"
!Monkey methodsFor: 'about x'!
setX: val
   x := val
!
x
  ^x
!!

aMonkey setX: 10 .
aMonkey inspect .
(aMonkey x) printNl .
