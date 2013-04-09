"assigning values to an array"
"suppose array is bound to an array of 20 values"
array at: 5 put: 'substitute fifth element'.

[ array at: 21 put: 'error' ]
   on: SystemExceptions.IndexOutOfRange
   do: [ :sig | 'Out of range!' displayNl ].
