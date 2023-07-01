/*REXX program demonstrates a  DO WHILE  with index reduction construct.*/
                                       /* [↓] note:   BY   defaults to 1*/
        do j=1024  by 0  while  j>>0   /*this is an  exact  comparison. */
        say right(j,10)                /*pretty output by aligning right*/
        j=j%2                          /*in REXX, % is integer division.*/
        end
                                       /*stick a fork in it, we're done.*/
