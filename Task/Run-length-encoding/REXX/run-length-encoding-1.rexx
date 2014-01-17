/*REXX program  encodes  a string  by using a  run-length  scheme.      */
parse arg x .                          /*normally, input would be a file*/
/*═══ arg x . ═══*/                    /*◄── use if X must be uppercase.*/
def= 'WWWWWWWWWWWWBWWWWWWWWWWWWBBBWWWWWWWWWWWWWWWWWWWWWWWWBWWWWWWWWWWWWWW'
if x=''  then x=def                    /*No input? Then use the default.*/
Lx=length(x)                           /*get the length of the X string.*/
y=                                     /*Y is the output string (so far)*/
    do j=1  by 0  to Lx                /*J   is incremented  (below).   */
    c=substr(x,j,1)                    /*pick a character, check for err*/
    if \datatype(c,'M')  then do; say "error!: data isn't alphabetic:" c; exit 13; end
    r=0                                /*R  is NOT the number of chars. */
                  do k=j+1  to Lx  while  substr(x,k,1)==c
                  r=r+1                /*R  is a replication count.     */
                  end   /*k*/
    j=j+1+r                            /*modify (add to) the do index.  */
    if r==0  then r=                   /*don't use   R   if  R  is zero.*/
    Y = Y || r || c                    /*add it to the  encoded  string.*/
    end   /*j*/

say '  input=' x
say 'encoded=' y
                                       /*stick a fork in it, we're done.*/
