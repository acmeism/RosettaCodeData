/*REXX program  encodes  a string  by using a  run─length  encoding scheme.   */
parse arg x .                          /*normally, input would be in a file.  */
def= 'WWWWWWWWWWWWBWWWWWWWWWWWWBBBWWWWWWWWWWWWWWWWWWWWWWWWBWWWWWWWWWWWWWW'
if x=''  then x=def                    /*Input not specified? Then use default*/
Lx=length(x)                           /*get the length of the  X  string.    */
y=                                     /*Y:  is the output string  (so far).  */
   do j=1  by 0  to Lx                 /*J:  is incremented within the loop.  */
   c=substr(x,j,1)                     /*pick a character, check for an error.*/
   if \datatype(c,'M')  then do; say "error!: data isn't alphabetic:" c; exit 13; end
   r=0                                 /*R:  is NOT the number of characters. */
            do k=j+1  to Lx  while  substr(x,k,1)==c;   r=r+1
            end   /*k*/                /*R:  is a replication count for a char*/
   j=j+1+r                             /*increment (add to) the DO loop index.*/
   if r==0  then r=                    /*don't use  R  if it is equal to zero.*/
   Y = Y || r || c                     /*add character to the encoded string. */
   end   /*j*/

say '  input='  x
say 'encoded='  y                      /*stick a fork in it,  we're all done. */
