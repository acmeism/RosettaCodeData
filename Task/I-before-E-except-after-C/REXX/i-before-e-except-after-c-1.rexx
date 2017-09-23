/*REXX program shows  plausibility  of  "I before E"  when not preceded by C,  and      */
/*───────────────────────────────────── "E before I"  when     preceded by C.           */
parse arg iFID .                                 /*obtain optional argument from the CL.*/
if iFID=='' | iFID=="," then iFID='UNIXDICT.TXT' /*Not specified?  Then use the default.*/
#.=0                                             /*zero out the various word counters.  */
     do r=0  while  lines(iFID)\==0              /*keep reading the dictionary 'til done*/
     u=space( lineIn(iFID), 0);      upper u     /*elide superfluous blanks and tabs.   */
     if u==''  then iterate                      /*Is it a blank line?   Then ignore it.*/
     #.words=#.words + 1                         /*keep running count of number of words*/
     if pos('EI', u)\==0 & pos('IE', u)\==0  then #.both=#.both + 1  /*the word has both*/
     call find  'ie'                                                 /*look for   ie    */
     call find  'ei'                                                 /*  "   "    ei    */
     end   /*r*/                                 /*at exit of DO loop,   R = # of lines.*/

L=length(#.words)                                /*use this to align the output numbers.*/
say 'lines in the  '         iFID         " dictionary: "            r
say 'words in the  '         iFID         " dictionary: "            #.words
say
say 'words with "IE" and "EI" (in same word): '    right(#.both, L)
say 'words with "IE" and     preceded by "C": '    right(#.ie.c ,L)
say 'words with "IE" and not preceded by "C": '    right(#.ie.z ,L)
say 'words with "EI" and     preceded by "C": '    right(#.ei.c ,L)
say 'words with "EI" and not preceded by "C": '    right(#.ei.z ,L)
say;                         mantra= 'The spelling mantra  '
p1=#.ie.z / max(1, #.ei.z);  phrase= '"I before E when not preceded by C"'
say mantra phrase   ' is '   word("im", 1 + (p1>2) )'plausible.'
p2=#.ie.c / max(1, #.ei.c);  phrase= '"E before I when     preceded by C"'
say mantra phrase   ' is '   word("im", 1 + (p2>2) )'plausible.'
po=(p1>2 & p2>2);            say 'Overall, it is'    word("im", 1 + po)'plausible.'
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
find: arg x;  s=1;  do forever;           _=pos(x, u, s);          if _==0  then return
                    if substr(u, _ - 1 + (_==1)*999, 1)=='C'  then #.x.c=#.x.c + 1
                                                              else #.x.z=#.x.z + 1
                    s=_ + 1                      /*handle the cases of multiple finds.  */
                    end   /*forever*/
