/*REXX program demonstrates disjointed array usage. */
yr.='year not supported'     /*value for all   yr.xxx     (so far).  */

     do k=600 to 1100        /*Define a bunch of years prior to 1800.*/
     yr.k=k "AD"
     end

  do j=1800 to 2100          /*start at 1800, define a bunch of years*/
  yr.j=j 'AD'                /*define Jth element as the year itself.*/
  end                        /*the above defines 301 elements.       */

year=1946
say 'DOB' year "is:" yr.year

year=1744
say 'DOB' year "is:" yr.year
