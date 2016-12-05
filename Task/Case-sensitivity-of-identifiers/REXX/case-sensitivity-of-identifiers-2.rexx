/*REXX program demonstrate case sensitive REXX  index  names  (for compound variables). */

 /*  ┌──◄── all 3 indices (for an array variable)  are unique  (as far as array index). */
 /*  │                                                                                  */
 /*  ↓                                                                                  */
x= 'dog';  dogname.x= "Gunner"                   /*assign an array index,  lowercase dog*/
x= 'Dog';  dogname.x= "Thor"                     /*   "    "   "     "   capitalized Dog*/
x= 'DOG';  dogname.x= "Jax"                      /*   "    "   "     "     uppercase DOG*/
x= 'doG';  dogname.x= "Rex"                      /*   "    "   "     "       mixed   doG*/

                              say center('using compound variables', 35, "═")   /*title.*/
                              say

_= 'dog';  say "dogname.dog="  dogname._         /*display an array index, lowercase dog*/
_= 'Dog';  say "dogname.Dog="  dogname._         /*   "     "   "     "  capitalized Dog*/
_= 'DOG';  say "dogname.DOG="  dogname._         /*   "     "   "     "    uppercase DOG*/
_= 'doG';  say "dogname.doG="  dogname._         /*   "     "   "     "      mixed   doG*/

                                                 /*stick a fork in it,  we're all done. */
