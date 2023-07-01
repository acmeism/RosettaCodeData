/*REXX program finds words  (within an identified dict.)  to solve a word ladder puzzle.*/
parse arg base targ iFID .                       /*obtain optional arguments from the CL*/
if base=='' | base=="," then base= 'boy'         /*Not specified?  Then use the default.*/
if targ=='' | targ=="," then targ= 'man'         /* "      "         "   "   "     "    */
if iFID=='' | iFID=="," then iFID='unixdict.txt' /* "      "         "   "   "     "    */
abc=  'abcdefghijklmnopqrstuvwxyz'               /*the lowercase (Latin) alphabet.      */
abcU= abc;    upper abcU                         /* "  uppercase    "        "          */
base= lower(base);           targ= lower(targ)   /*lowercase the BASE and also the TARG.*/
   L= length(base)                               /*length of the BASE  (in characters). */
if L<2  then call err 'base word is too small or missing'              /*oops, too small*/
if length(targ)\==L  then call msg , "target word isn't the same length as the base word"
call letters                                     /*assign letters,  faster than SUBSTR. */
#= 0                                             /*# of words whose length matches BASE.*/
@.=                                              /*default value of any dictionary word.*/
         do recs=0  while lines(iFID)\==0        /*read each word in the file  (word=X).*/
         x= lower(strip( linein( iFID) ) )       /*pick off a word from the input line. */
         if length(x)\==L  then iterate          /*Word not correct length?  Then skip. */
         #= # + 1;         @.x= 1                /*bump # words with length L; semaphore*/
         end   /*recs*/                          /* [↑]   semaphore name is uppercased. */
!.= 0
say copies('─', 30)     recs       "words in the dictionary file: "       iFID
say copies('─', 30)       #        "words in the dictionary file of length: "  L
say copies('─', 30)   ' base  word is: '  base
say copies('─', 30)   'target word is: '  targ
rung= targ
$= base
           do f=1  for m;    call look;  if result\==''  then leave      /*Found?  Quit.*/
           end   /*f*/
say
if f>m  then call msg  'no word ladder solution possible for '   base   " ──► "   targ

               do f-2;       $= base;    !.= 0   /*process all the rungs that were found*/
                 do forever; call look;  if result\==''  then leave      /*Found?  Quit.*/
                 end   /*forever*/
               end     /*f-2*/
call show words(rung)
exit 0                                           /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
msg:  say;   if arg()==2  then say '***error*** ' arg(2);  else say arg(1);  say;  exit 13
show: say 'a solution: ' base; do j=1 to arg(1); say left('',12) word(rung,j); end; return
letters:     do m=1  for length(abc);         a.m= substr(abc, m, 1);         end;  return
/*──────────────────────────────────────────────────────────────────────────────────────*/
look: procedure expose @. !. a. $ abc base L rung targ search;        rungs= word(rung, 1)
      $$=;                                                            rung#= words(rungs)
              do i=1  for words($);                  y= word($, i);     !.y= 1
                 do k=1  for L
                    do n=1  for 26;  z= overlay(a.n, y, k)             /*change a letter*/
                    if @.z==''  then iterate       /*Is this not a word?  Then skip it. */
                    if !.z      then iterate       /* "   "   a  repeat?    "    "   "  */
                    if z==rungs then rung= y rung  /*prepend a word to the rung list.   */
                    if z==rungs & rung#>1  then return z               /*short─circuit. */
                    if z==targ  then return z
                    $$= $$ z                       /*append a possible ladder word to $$*/
                    end   /*n*/
                 end      /*k*/
              end         /*i*/
      $= $$;                         return ''
