/* REXX ----------------------------------------------
* The compond variable a. implements an array
* By convention, a.0 contains the number of elements
*---------------------------------------------------*/
a.=0                   /* initialize the "array" */
call store 'apple'
Call store 'orange'
Say 'There are' a.0 'elements in the array:'
Do i=1 To a.0
  Say 'Element' i':' a.i
  End
Exit
store: Procedure Expose a.
z=a.0+1
a.z=arg(1)
a.0=z
Return
