/*REXX program solves a  "Pyramid of Numbers"  puzzle given four values.*/
          /*┌──────────────────────────────────────────────┐
          ┌─┘                                              └─┐
          │                              answer              │
          │             mid             /                    │
          │               \            /                     │
          │                \        151                      │
          │                 \   ααα     ααα                  │
          │                  40    ααα    ααα                │
          │              ααα    ααα    ααα    ααα            │
          │           x      11     y      4       z         │
          │                 /               \                │
          │                /                 \               │
          │               /                   \              │
          │              B                     D             │
          └─┐                                              ┌─┘
            └──────────────────────────────────────────────┘*/
parse arg x b y d z mid answer .       /*get some values, others, just X*/
   pad=left('',15)                     /*for inserting spaces in output.*/
   top=answer - 4*b - 4*d              /*calculate the top # - constants*/
middle=mid - 2*b                       /*calculate the mod # - constants*/

  do x  =-top  to top
    do y=-top  to top
    if x+y\==middle   then iterate     /*40 = x+2B+Y  -or-  40-2*11 =x+y*/
    y6=y*6                             /*calculate a short cut.         */
           do z=-top  to top
           if z\==y-x     then iterate /*z has to equal y-x  (y=x+z)    */
           if x+y6+z==top then say pad 'x = ' x pad "y = " y pad 'z = ' z
           end   /*z*/
    end          /*y*/
  end            /*x*/
                                       /*stick a fork in it, we're done.*/
