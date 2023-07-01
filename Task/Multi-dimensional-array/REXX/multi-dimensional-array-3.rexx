/*REXX program shows how to  assign and/or display  values of a multi─dimensional array.*/
                                                 /*REXX arrays can start anywhere.      */
y.=0                                             /*set all values of   Y   array to  0. */
                                                 /* [↑]  bounds need not be specified.  */
#=0                                              /*the count for the number of   SAYs.  */
y.4.3.2.0= 3**7                                  /*set penultimate element to   2187    */
                      do       i=0  for 5
                        do     j=0  for 4
                          do   k=0  for 3
                            do m=0  for 2;   #=#+1             /*bump the  SAY  counter.*/
/*the 1st SAY──► */         say  'y.'i"."j'.'k"."m   '='   y.i.j.k.m
                            end   /*m*/
                          end     /*k*/
                        end       /*j*/
                      end         /*i*/
say
say '# of elements displayed = '  #              /*should be   5 * 4 * 3 * 2    or   5! */
exit                                             /*stick a fork in it,  we're all done. */

                   /* [↓]   other versions of the first (REXX)   SAY   instruction. */
                      say  'y.' || i || . || k || . || m  '='  y.i.j.k.m
                      say  'y.'||i||.||k||.||m            '='  y.i.j.k.m
                      say  'y.'i||.||k||.||m              '='  y.i.j.k.m
