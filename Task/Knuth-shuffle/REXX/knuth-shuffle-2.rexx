/* REXX ---------------------------------------------------------------
* 05.01.2014 Walter Pachl
*            borrow one improvement from version 1
* 06.01.2014 removed    -"-  (many tests cost more than few "swaps")
*--------------------------------------------------------------------*/
Call random ,,123456                   /* seed for random            */
Do i=1 To 10; a.i=i; End;              /* fill array                 */
Call show 'In',10                      /* show start                 */
do i = 10 To 2 By -1                   /* shuffle                    */
  j=random(i-1)+1;
  h=right(i,2) right(j,2)
  Parse Value a.i a.j With a.j a.i     /* a.i <-> a.j                */
  Call show h,i                        /* show intermediate states   */
  end;
Call show 'Out',10                     /* show fomaö state           */
Exit

show: Procedure Expose a.
Parse Arg txt,n
ol=left(txt,6);
Do k=1 To n; ol=ol right(a.k,2); End
Say ol
Return
