/*REXX program searches a collection of strings.                        */
hay.=                                  /*initialize haystack collection.*/
hay.1  = 'sodium'
hay.2  = 'phosphorous'
hay.3  = 'californium'
hay.4  = 'copernicium'
hay.5  = 'gold'
hay.6  = 'thallium'
hay.7  = 'carbon'
hay.8  = 'silver'
hay.9  = 'curium'
hay.10 = 'copper'
hay.11 = 'helium'
hay.12 = 'sulfur'

needle='gold'                          /*we'll be looking for the gold. */
upper needle                           /*in case some people capitalize.*/
found=0                                /*assume needle isn't found yet. */

          do j=1  while hay.j\==''     /*keep looking in haystack.      */
          _=hay.j;     upper _         /*make it uppercase to be safe.  */
          if _=needle  then do         /*we've found needle in haystack.*/
                            found=1    /*indicate that needle was found,*/
                            leave      /*  and stop looking, of course. */
                            end
          end   /*j*/

if found  then return j                /*return haystack index number.  */
          else say  needle  "wasn't found in the haystack!"
return 0                               /*indicates needle wasn't found. */
