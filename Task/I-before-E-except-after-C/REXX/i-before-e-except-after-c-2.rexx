/*REXX program shows  plausibility  of  "I before E"  when not preceded by C,  and      */
/*───────────────────────────────────── "E before I"  when     preceded by C,  using a  */
/*───────────────────────────────────── weighted frequency for each word.               */
parse arg iFID wFID .                            /*obtain optional arguments from the CL*/
if iFID=='' | iFID=="," then iFID='UNIXDICT.TXT' /*Not specified?  Then use the default.*/
if wFID=='' | wFID=="," then wFID='WORDFREQ.TXT' /* "      "         "   "   "     "    */
cntl=xrange(, ' ')                               /*get all manner of tabs, control chars*/
#.=0                                             /*zero out the various word counters.  */
f.=1                                             /*default word frequency multiplier.   */
    do recs=0  while lines(wFID)\==0             /*read a record from the file 'til done*/
    u=translate( linein(wFID), , cntl);  upper u /*translate various tabs and cntl chars*/
    u=translate(u, '*', "~")                     /*translate tildes (~)  to an asterisk.*/
    if u==''                 then iterate        /*Is this a blank line? Then ignore it.*/
    freq=word(u, words(u) )                      /*obtain the last token on the line.   */
    if \datatype(freq, 'W')  then iterate        /*FREQ not an integer?  Then ignore it.*/
    parse var  u   w.1  '/'  w.2  .              /*handle case of:   ααα/ßßß  ···       */

         do j=1  for 2;  w.j=word(w.j, 1)        /*strip leading and/or trailing blanks.*/
         _=w.j;   if _==''          then iterate /*if not present, then ignore it.      */
         if j==2  then if w.2==w.1  then iterate /*second word ≡ first word?  Then skip.*/
         #.freqs=#.freqs + 1                     /*bump word counter in the  FREQ  list.*/
         f._=f._ + freq                          /*add to a word's frequency count.     */
         end   /*ws*/
    end        /*recs*/                          /*at exit of DO loop, RECS = # of recs.*/

if    recs\==0  then say 'lines in the  '        wFID        "       list: "      recs
if #.freqs\==0  then say 'words in the  '        wFID        "       list: "      #.freqs
if #.freqs ==0  then weighted=
                else weighted= ' (weighted)'
say
    do r=0  while  lines(iFID)\==0               /*keep reading the dictionary 'til done*/
    u=space( linein(iFID), 0);      upper u      /*elide superfluous blanks and tabs.   */
    if u==''  then iterate                       /*Is it a blank line?   Then ignore it.*/
    #.words=#.words + 1                          /*keep running count of number of words*/
    one=f.u
    if pos('EI', u)\==0 & pos('IE', u)\==0  then #.both=#.both + one /*the word has both*/
    call find  'ie'                                                  /*look for   ie    */
    call find  'ei'                                                  /*  "   "    ei    */
    end   /*r*/                                  /*at exit of DO loop,   R = # of lines.*/

L=length(#.words)                                /*use this to align the output numbers.*/
say 'lines in the  '         iFID         ' dictionary: '             r
say 'words in the  '         iFID         ' dictionary: '             #.words
say
say 'words with "IE" and "EI" (in same word): '    right(#.both, L)   weighted
say 'words with "IE" and     preceded by "C": '    right(#.ie.c ,L)   weighted
say 'words with "IE" and not preceded by "C": '    right(#.ie.z ,L)   weighted
say 'words with "EI" and     preceded by "C": '    right(#.ei.c ,L)   weighted
say 'words with "EI" and not preceded by "C": '    right(#.ei.z ,L)   weighted
say;                         mantra= 'The spelling mantra  '
p1=#.ie.z / max(1, #.ei.z);  phrase= '"I before E when not preceded by C"'
say mantra phrase   ' is '   word("im", 1 + (p1>2) )'plausible.'
p2=#.ie.c / max(1, #.ei.c);  phrase= '"E before I when     preceded by C"'
say mantra phrase   ' is '   word("im", 1 + (p2>2) )'plausible.'
po=(p1>2 & p2>2);            say 'Overall, it is'    word("im",1 + po)'plausible.'
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
find: arg x;  s=1;  do forever;           _=pos(x, u, s);          if _==0  then return
                    if substr(u, _ - 1 + (_==1)*999, 1)=='C'  then #.x.c=#.x.c + one
                                                              else #.x.z=#.x.z + one
                    s=_ + 1                      /*handle the cases of multiple finds.  */
