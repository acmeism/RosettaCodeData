/*REXX program to loop through a 2-dimensional array to look for a '20'.*/
rows=60
cols=10
          do row    =1 for rows                    /*1st dimension ∙∙∙  */
              do col=1 for cols                    /*2nd dimension ∙∙∙  */
              @.row.col=random(1,20)               /*generate some nums.*/
              end   /*row*/
          end       /*col*/
/*─────────────────────────────────────now, search for the hidden twenty*/
                              do r    =1  for rows
                                  do c=1  for cols
                                  say left('@.'r"."c,9) '=' right(@.r.c,4)
                                  if @.r.c==20 then leave r
                                  end   /*c*/
                              end       /*r*/

say right(' Done with Loops/Nested. ',50,'─')
                                       /*stick a fork in it, we're done.*/
