[
   bla := someObject fooBar.
   foo := bla.
] on: MessageNotUnderstood do:[:ex |
   ((ex message selector == #fooBar) and: [ ex message receiver == someObject])
   ifTrue:[
       ex return: 'fortyTwo'
   ] ifFalse:[
       ex reject
   ]
]
