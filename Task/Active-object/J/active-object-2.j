cocurrent 'testrig'

delay=: 6!:3

object=: conew 'activeobject'
setinput__object 1&o.@o.`''
smoutput (T__object,getoutput__object) ''

delay 2

smoutput (T__object,getoutput__object) ''
setinput__object 0:`''
smoutput (T__object,getoutput__object) ''

delay 0.5

smoutput (T__object,getoutput__object) ''
