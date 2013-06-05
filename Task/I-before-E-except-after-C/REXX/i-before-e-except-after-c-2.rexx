/*REXX pgm shows plausibility of I before E when not preceded by C,  and*/
/*────────────────────────────── E before I when preceded by  C  using a*/
/*────────────────────────────── weighted frequency for each word.      */
#.=0                                   /*zero out various word counters.*/
parse arg iFID wFID .
if iFID=='' | iFID==','  then iFID='UNIXDICT.TXT'    /*use the default? */
if wFID=='' | wFID==','  then wFID='WORDFREQ.TXT'    /*use the default? */
tabs=xrange('0'x, "f"x)
f.=1                                   /*default word freq. multiplier. */

  do recs=0  while lines(wFID)\==0;  _=linein(wFID)  /*get a record.    */
  u=translate(_,,tabs);   upper u      /*trans various tabs & low hexex.*/
  u=translate(u,'*', "~")              /*translate tildes to an asterisk*/
  if u==''                then iterate /*if a blank line, then ignore it*/
  freq=word(u,words(u))                /*get the last token on the line.*/
  if \datatype(freq,'W')  then iterate /*Not numeric?   Then ignore it. */
  parse var u w.1 '/' w.2 .            /*handle case of:   ααα/ßßß  ... */

     do j=1  for 2;  w.j=word(w.j,1)   /*strip leading/trailing blanks  */
     _=w.j;   if _==''  then iterate   /*if not present, then ignore it.*/
     if j==2  then if w.2==w.1  then iterate  /*2nd word=1st word? skip.*/
     #.freqs = #.freqs + 1             /*bump word count in  FREQ  list.*/
     f._ = f._ + freq                  /*add to a word's frequency count*/
     end   /*ws*/

  end   /*recs*/

if recs\==0     then say 'lines in the  ' wFID '       list: '     recs
if #.freqs\==0  then say 'words in the  ' wFID '       list: '     #.freqs
if #.freqs==0   then weighted=
                else weighted=' (weighted)'
say

  do r=0  while lines(iFID)\==0;    _=linein(iFID)  /*get a single line.*/
  u=space(_,0);  upper u               /*elide superfluous blanks & tabs*/
  if u==''             then iterate    /*if a blank line, then ignore it*/
  #.words=#.words+1                    /*keep a running count of #words.*/
  one=f.u
  if pos('EI',u)\==0 & pos('IE',u)\==0 then #.both=#.both+one /*has both*/
  call find 'ie'
  call find 'ei'
  end   /*r*/

L=length(#.words)                      /*use this to align the output #s*/
say 'lines in the  ' iFID ' dictionary: '              r
say 'words in the  ' iFID ' dictionary: '              #.words
say
say 'words with "IE" and "EI" (in same word): '  right(#.both,L)  weighted
say 'words with "IE" and     preceded by "C": '  right(#.ie.c ,L) weighted
say 'words with "IE" and not preceded by "C": '  right(#.ie.z ,L) weighted
say 'words with "EI" and     preceded by "C": '  right(#.ei.c ,L) weighted
say 'words with "EI" and not preceded by "C": '  right(#.ei.z ,L) weighted
say;                 mantra='The spelling mantra  '
p1=#.ie.z/max(1,#.ei.z);   phrase='"I before E when not preceded by C"'
say mantra phrase ' is '   word("im", 1+(p1>2))'plausible.'
p2=#.ie.c/max(1,#.ei.c);   phrase='"E before I when     preceded by C"'
say mantra phrase ' is '   word("im", 1+(p2>2))'plausible.'
po=p1>2 & p2>2;   say 'Overall, it is' word("im",1+po)'plausible.'
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────FIND subroutine─────────────────────*/
find: arg x; s=1; do forever;      _=pos(x,u,s);      if _==0 then leave
                  if substr(u,_-1+(_==1)*999,1)=='C'  then #.x.c=#.x.c+one
                                                      else #.x.z=#.x.z+one
                  s=_+1                /*handle case of multiple finds. */
                  end   /*forever*/
return
