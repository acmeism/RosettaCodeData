/*REXX program encodes string by using a run-length scheme  (min len=2).*/
parse arg x                            /*normally, input would be a file*/
def='WWWWWWWWWWWWBWWWWWWWWWWWWBBBWWWWWWWWWWWWWWWWWWWWWWWWBWWWWWWWWWWWWWW'
if x==''  then x=def                   /*No input?  Then use the default*/
Lx=length(x)                           /*get the length of the X string.*/
y=                                     /*Y is the output string (so far)*/
    do j=1  to Lx                      /*warning!  J  is modified below.*/
    c=substr(x,j,1)                    /*pick a character, check for err*/
    if \datatype(c,'m') then do;say "error!: data isn't alphabetic";exit 13; end
    r=0                                /*R  is NOT the number of chars. */

      do k=j+1  to Lx  while  substr(x,k,1)==c
      r=r+1                            /*R  is a replication count.     */
      end   /*k*/

    if r==0  then Y = Y || c           /*C  wan't repeated, just OUT it.*/
             else Y = Y || r || c      /*add it to the encoded string.  */
    j=j+r                              /*A bad thing to do, but simple. */
    end   /*j*/

say '  input=' x
say 'encoded=' y
                                       /*stick a fork in it, we're done.*/
