/*REXX program selects all even numbers from an array and puts them   */
/* into a new array.                                                  */
Parse Arg n seed .                /* obtain optional arguments from CL*/
If n==''|n=="," Then n=50         /* Not specified?  use the default  */
If datatype(seed,'W') Then
  Call random,,seed               /* use RANDOM seed for repeatability*/
Do i=1 For n                      /* generate  N  random numbers      */
  old.i=random(1,99999)           /* generate random number           */
  End
m=0                               /* number of elements in NEW        */
Do j=1 To n                       /* process the elements of the OLD  */
  If old.j//2==0 Then Do          /* if element is even, then         */
    m=m+1                         /* bump the number of NEW elemens   */
    new.m=old.j                   /* assign the number to the NEW     */
    End
  End
Do k=1 For m                      /* display all the NEW numbers.     */
  Say right('new.'k,20) '=' right(new.k,9)
  End
