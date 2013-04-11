/*REXX program decodes string by using a run-length scheme  (min len=2).*/
parse arg x                            /*normally, input would be a file*/
if x==''  then x='11WB11W2B23WB13W'    /*No input?  Then use the default*/
Lx=length(x)                           /*get the length of the X string.*/
y=                                     /*Y is the output string (so far)*/
    do j=1  to Lx                      /*warning!  J  is modified below.*/
    c=substr(x,j,1)
    if \datatype(c,'W') then do        /*a loner char, simply add to OUT*/
                             y=y || c
                             iterate
                             end
    d=1
        do k=j+1 to Lx while datatype(substr(x,k,1),'w') /*look for #end*/
        d=d+1                          /*d is the number of digs so far.*/
        end   /*k*/

    n=substr(x,j,d)+1                  /*D  is length of encoded number.*/
    y=y || copies(substr(x,k,1),n)     /*N  is now the number of chars. */
    j=j+d                              /*A bad thing to do, but simple. */
    end   /*j*/

say '  input=' x
say 'decoded=' y
                                       /*stick a fork in it, we're done.*/
