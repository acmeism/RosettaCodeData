/*REXX pgm shows plausibility of I before E when not preceded by C,  and*/
/*────────────────────────────── E before I when preceded by C.         */
#.=0                                   /*zero out various word counters.*/
parse arg iFID .;   if iFID=='' then iFID='UNIXDICT.TXT'  /*use default?*/

  do r=0  while lines(ifid)\==0;    _=linein(iFID)  /*get a single line.*/
  u=translate(space(_,0))              /*elide superfluous blanks & tabs*/
  if u==''             then iterate    /*if a blank line, then ignore it*/
  #.words=#.words+1                    /*keep a running count of #words.*/
  if pos('EI',u)\==0 & pos('IE',u)\==0 then #.both=#.both+1  /*has both.*/
  call find 'ie'
  call find 'ei'
  end   /*r*/

L=length(#.words)                      /*use this to align the output #s*/
say 'lines in the  ' ifid ' dictionary: '              r
say 'words in the  ' ifid ' dictionary: '              #.words
say
say 'words with "IE" and "EI" (in same word): '  right(#.both,L)
say 'words with "IE" and     preceded by "C": '  right(#.ie.c ,L)
say 'words with "IE" and not preceded by "C": '  right(#.ie.z ,L)
say 'words with "EI" and     preceded by "C": '  right(#.ei.c ,L)
say 'words with "EI" and not preceded by "C": '  right(#.ei.z ,L)
say;                 mantra='The spelling mantra  '
p1=#.ie.z/max(1,#.ei.z);   phrase='"I before E when not preceded by C"'
say mantra phrase ' is '   word("im", 1+(p1>2))'plausible.'
p2=#.ie.c/max(1,#.ei.c);   phrase='"E before I when     preceded by C"'
say mantra phrase ' is '   word("im", 1+(p2>2))'plausible.'
po=p1>2 & p2>2;   say 'Overall, it is' word("im",1+po)'plausible.'
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────FIND subroutine─────────────────────*/
find: arg x;  s=1;  do forever;      _=pos(x,u,s);      if _==0 then leave
                    if substr(u,_-1+(_==1)*999,1)=='C'  then #.x.c=#.x.c+1
                                                        else #.x.z=#.x.z+1
                    s=_+1              /*handle case of multiple finds. */
                    end   /*forever*/
return
