/*REXX program  decodes a string by using a  run─length  decoding scheme.     */
parse arg x .                          /*normally, input would be in a file.  */
if x==''  then x=11WB11W2B23WB13W      /*X  not specified?   Then use default.*/
Lx=length(x)                           /*get the length of the input string.  */
y=                                     /*Y:  is the output string  (so far).  */
    do j=1  by 0  to Lx                /*warning!  J  is modified within loop.*/
    c=substr(x,j,1)
    if \datatype(c,'W') then do        /*a loner char, simply add to output.  */
                             y=y || c;     j=j+1;      iterate  /*j*/
                             end
    d=1                                            /* [↓]  W:  a Whole number.*/
        do k=j+1  to Lx  while datatype(substr(x,k,1),'w'); d=d+1  /*end of #?*/
        end   /*k*/                    /*D: is the number of characters so far*/

    n=substr(x,j,d)+1                  /*D:  is length of the encoded number. */
    y=y || copies(substr(x,k,1), n)    /*N:  is now the number of characters. */
    j=j+1+d                            /*increment the DO loop index by D+1.  */
    end   /*j*/

say '  input=' x
say 'decoded=' y                       /*stick a fork in it,  we're all done. */
