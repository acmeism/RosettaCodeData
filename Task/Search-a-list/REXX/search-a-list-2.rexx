/*REXX program searches a collection of strings   (an array of periodic table elements).*/
hay.0   =      1000                              /*safely indicate highest item number. */
hay.200 = 'Binilnilium'
hay.98  = 'californium'
hay.6   = 'carbon'
hay.112 = 'copernicium'
hay.29  = 'copper'
hay.114 = 'flerovium'
hay.79  = 'gold'
hay.2   = 'helium'
hay.1   = 'hydrogen'
hay.82  = 'lead'
hay.116 = 'livermorium'
hay.15  = 'phosphorous'
hay.47  = 'silver'
hay.11  = 'sodium'
hay.16  = 'sulfur'
hay.81  = 'thallium'
hay.92  = 'uranium'
                                                 /* [↑]  sorted by the element name.    */
needle  = 'gold'                                 /*we'll be looking for the gold.       */
upper needle                                     /*in case some people capitalize.      */
found=0                                          /*assume the needle isn't found  (yet).*/

          do j=1  for hay.0                      /*start looking in haystack,  item 1.  */
          _=hay.j;     upper _                   /*make it uppercase just to be safe.   */
          if _=needle  then do;  found=1         /*we've found the needle in haystack.  */
                                 leave           /*  ··· and stop looking, of course.   */
                            end
          end   /*j*/

if found  then return j                          /*return the haystack  index  number.  */
          else say  needle  "wasn't found in the haystack!"
return 0                                         /*indicates the needle  wasn't  found. */
