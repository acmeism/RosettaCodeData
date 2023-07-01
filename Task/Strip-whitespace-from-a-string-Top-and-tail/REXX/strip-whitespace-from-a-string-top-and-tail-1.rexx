/*REXX program demonstrates  how to  strip  leading  and/or  trailing  spaces (blanks). */
yyy="   this is a string that has leading/embedded/trailing blanks,  fur shure.  "
say 'YYY──►'yyy"◄──"                             /*display the original string + fence. */
                      /*white space also includes tabs (VT, HT), among other characters.*/

                      /*all examples in each group are equivalent, only the option's 1st*/
                      /*character is examined.                                          */
noL=strip(yyy,'L')                               /*elide any  leading white space.      */
noL=strip(yyy,"l")                               /*  (the same as the above statement.) */
noL=strip(yyy,'leading')                         /*    "    "   "  "    "       "       */
say 'noL──►'noL"◄──"                             /*display the string with a title+fence*/

noT=strip(yyy,'T')                               /*elide any trailing white space.      */
noT=strip(yyy,"t")                               /*  (the same as the above statement.) */
noT=strip(yyy,'trailing')                        /*    "    "   "  "    "       "       */
say 'noT──►'noT"◄──"                             /*display the string with a title+fence*/

noB=strip(yyy)                                   /*elide leading & trailing white space.*/
noB=strip(yyy,)                                  /*  (the same as the above statement.) */
noB=strip(yyy,'B')                               /*    "    "   "  "    "       "       */
noB=strip(yyy,"b")                               /*    "    "   "  "    "       "       */
noB=strip(yyy,'both')                            /*    "    "   "  "    "       "       */
say 'noB──►'noB"◄──"                             /*display the string with a title+fence*/

                                                 /*elide leading & trailing white space,*/
noX=space(yyy)                                   /* including white space between words.*/
say 'nox──►'noX"◄──"                             /*display the string with a title+fence*/
                                                 /*stick a fork in it,  we're all done. */
