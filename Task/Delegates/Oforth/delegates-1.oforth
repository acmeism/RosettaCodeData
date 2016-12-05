Object Class new: Delegate1

Object Class new: Delegate2
Delegate2 method: thing  "Delegate implementation" println ;

Object Class new: Delegator(delegate)
Delegator method: initialize  := delegate ;

Delegator method: operation
   @delegate respondTo(#thing) ifTrue: [ @delegate thing return ]
   "Default implementation" println ;
