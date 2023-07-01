/* REXX ***************************************************************
* Demonstrate how the history of assignments can be kept and shown
* 13.07.2012 Walter Pachl  Rewrite of Version 1 for (my) readability
*   varset.i.varu contains the ith value assigned to var
*   varset.0.varu contains the number of assignments so far
**********************************************************************/
varset.=0                          /*initialize the assignment count */

call varset 'fluid',min(0,-5/2,-1)   ; say 'fluid=' fluid
call varset 'fluid',3.14159          ; say 'fluid=' fluid
call varset 'fluid',3.14159          ; say 'fluid=' fluid
call varset 'fluid',' Santa  Claus'  ; say 'fluid=' fluid
call varset 'FLUID',' Easter Rabbit' ; say 'fluid=' fluid

say 'There were' varset('fluid',,'L'),
    'assignments (sets) for the FLUID variable.'
exit

varset: Procedure Expose varset.
/**********************************************************************
* record values assigned to var (=varu as Rexx is case insensitive)
* Invoke with list<>'' to list the sequence of assigned values
* and return the number of assignments made (using this routine)
**********************************************************************/
  Parse Upper Arg varu              /* name of variable in uppercase */
  Parse arg var,value,list          /*varName, value, optional-List. */

  if list='' then do                /*not list, so set the X variable*/
    z=varset.0.varu+1               /*bump the history count (SETs). */
    varset.z.varu=value             /* ... and store it in "database"*/
    varset.0.varu=z                 /*the new history count          */
    call value var,value            /*now assign the value to var    */
    end
  else Do
    Say ''                          /*show blank line for readability*/
    do i=1 to varset.0.varu         /*list the assignment history    */
      say 'history entry' i "for var" var":" varset.i.varu
      end
    end
  Return varset.0.varu           /*return the number of assignments. */
