/*REXX program to show how to strip leading and/or trailing spaces.     */

yyy="   this is a string that has leading/embedded/trailing blanks,  fur shure.   "

                             /*white space also includes tabs (VT & HT),*/
                             /*among other characters.                  */

                             /*all examples in each group are equivalent*/
                             /*only the option's first char is examined.*/

      /*───────────────────────just remove the leading white space.     */
noL=strip(yyy,'L')
noL=strip(yyy,"l")
noL=strip(yyy,'leading')
g="Listen, birds / those signs cost money / so roost a while / but don't get funny / Burma-shave"
noL=strip(yyy,g)            /*a long way to go to fetch a pail of water.*/

      /*───────────────────────just remove the trailing white space.    */
noT=strip(yyy,'T')
noT=strip(yyy,"t")
noT=strip(yyy,'trailing')
noT=strip(yyy,'trains ride the rails')
j="Toughest Whiskers / In the town / We hold 'em up / You mow 'em down / Burma-Shave"
noT=strip(yyy,j)

      /*───────────────────────remove leading and trailing white space. */
noB=strip(yyy)
noB=strip(yyy,)
noB=strip(yyy,'B')
noB=strip(yyy,"b")
noB=strip(yyy,'both')
opt='Be a noble / Not a knave / Caesar uses / Burma-Shave'
noB=strip(yyy,opt)

      /*───────────────────────also remove all superfluous white space, */
noX=space(yyy)               /*   including white space between words.  */
