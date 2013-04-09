/*REXX program searches a collection of strings.                        */
hay.0=1000                             /*safely indicate highest item #.*/
hay.200 = 'binilnilium'
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

needle  = 'gold'                       /*we'll be looking for the gold. */
upper needle                           /*in case some people capitalize.*/
found=0                                /*assume needle isn't found, yet.*/

          do j=1  for hay.0            /*start looking in haystack item1*/
          _=hay.j;     upper _         /*make it uppercase to be safe.  */
          if _=needle  then do         /*we've found needle in haystack.*/
                            found=1    /*indicate that needle was found,*/
                            leave      /*  and stop looking, of course. */
                            end
          end   /*j*/

if found  then return j                /*return haystack index number.  */
          else say  needle  "wasn't found in the haystack!"
return 0                               /*indicates needle wasn't found. */

/*─────────────────────────────────────────────── incidentally, to find */
                                       /* the number of haystack items: */
hayItems=0

  do k=1  for hay.0                    /*find item  AFTER the last item.*/
  if hay.k\==''  then hayItems=hayItems+1       /*bump the item counter.*/
  end   /*k*/
                                       /*stick a fork in it, we're done.*/
