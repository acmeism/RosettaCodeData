/*REXX program  demonstrates  disjointed array usage.                   */
yr. = 'year not supported'             /*value for all yr.xxx  (so far).*/

                do k=600  to 1100      /*a bunch of years prior to 1800.*/
                yr.k=k "AD"            /*Kth element as the year itself.*/
                end   /*k*/            /* [↑]      defines 501 elements.*/

            do j=1800  to 2100         /*start at 1800, define a bunch. */
            yr.j=j 'AD'                /*Jth element as the year itself.*/
            end   /*j*/                /* [↑]      defines 301 elements.*/

year=1946
say 'DOB' year "is:" yr.year

year=1744
say 'DOB' year "is:" yr.year
                                       /*stick a fork in it, we're done.*/
