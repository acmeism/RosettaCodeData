/*REXX program  decodes a string by using a  run-length  scheme.        */
parse arg x .                          /*normally, input would be a file*/
if x==''  then x='11WB11W2B23WB13W'    /*No input?  Then use the default*/
Lx=length(x)                           /*get the length of the X string.*/
y=                                     /*Y is the output string (so far)*/
    do j=1  by 0  to Lx                /*warning!  J  is modified below.*/
    c=substr(x,j,1)
    if \datatype(c,'W') then do        /*a loner char, simply add to OUT*/
                             y=y || c;     j=j+1;      iterate  /*j*/
                             end
    d=1
        do k=j+1 to Lx while datatype(substr(x,k,1),'w') /*look for #end*/
        d=d+1                          /*D is the number of digs so far.*/
        end   /*k*/

    n=substr(x,j,d)+1                  /*D  is length of encoded number.*/
    y=y || copies(substr(x,k,1),n)     /*N  is now the number of chars. */
    j=j+1+d                            /*increment the DO loop index.   */
    end   /*j*/

say '  input=' x
say 'decoded=' y
                                       /*stick a fork in it, we're done.*/
