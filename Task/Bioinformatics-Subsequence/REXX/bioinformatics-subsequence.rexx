/*REXX pgm gens random DNA (ACGT) sequence & finds positions of a random 4─protein seq. */
parse arg totLen rndLen basePr oWidth Bevery rndDNA seed .
if totLen=='' | totLen==","  then totLen=   200  /*Not specified?  Then use the default.*/
if rndLen=='' | rndLen==","  then rndLen=     4  /* "      "         "   "   "     "    */
if basePr=='' | basePr==","  then basePr= 'acgt' /* "      "         "   "   "     "    */
if oWidth=='' | oWidth==","  then oWidth=   100  /* "      "         "   "   "     "    */
if Bevery=='' | Bevery==","  then Bevery=    10  /* "      "         "   "   "     "    */
if rndDNA=='' | rndDNA==","  then rndDNA=  copies(., rndLen)    /*what we're looking for*/
if datatype(seed, 'W')  then call random ,,seed  /*used to generate repeatable random #s*/
call genRnd                                      /*gen  data field of random proteins.  */
call show                                        /*show   "    "    "    "      "       */
say '  base DNA proteins used: '  basePr
say 'random DNA proteins used: '  dna?
call findRnd
if @=='' then do;  say "the random DNA proteins weren't found.";  exit 4;  end
say 'the random DNA proteins were found in positions:'     strip(@)
exit 0                                           /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
commas: parse arg ?;  do jc=length(?)-3  to 1  by -3; ?=insert(',', ?, jc); end;  return ?
/*──────────────────────────────────────────────────────────────────────────────────────*/
findRnd: @=;           p=0                       /*@:  list of the found target proteins*/
              do until p==0;    p= pos(dna?, $$, p+1);     if p>0  then @= @ commas(p)
   /*Found one?  Append it to the "Found"s*/
              end   /*p*/;             return
/*──────────────────────────────────────────────────────────────────────────────────────*/
genRnd: dna?=;        use= basePr;     upper use basePr rndDNA;       lenB= length(basePr)
              do k=1  for rndLEN;      x= substr(rndDNA, k, 1)
              if x==.  then  do;  ?= random(1, length(use) );         x= substr(use, ?, 1)
                                  use= delstr(use, ?, 1)   /*elide so no protein repeats*/
                             end
              dna?= dna? || x                              /*build a random protein seq.*/
              end   /*k*/
        return
/*──────────────────────────────────────────────────────────────────────────────────────*/
show: say " index │"center('DNA sequence of ' commas(totLen)  " proteins", oWidth+10)
      say "───────┼"center(''                                            , oWidth+10, '─')
      $=; $$=;                 idx= 1               /*gen data field of random proteins.*/
         do j=1  for totLen;   c= substr( basePr, random(1, lenB), 1)
          $$= $$ || c                                       /*append a random protein.  */
          if Bevery\==0  then if j//Bevery==0  then $= $' ' /*possibly add a blank.     */
          if length( space($ || c, 0) )<oWidth  then do;   $= $  ||  c;   iterate;   end
          say strip( right(idx, 7)'│' $, 'T');  $=          /*display line ──► terminal.*/
          idx= idx + oWidth                                 /*bump the index number.    */
          end   /*j*/
      if $\==''  then say right(idx, 7)"│" strip($, 'T')    /*show residual protein data*/
      say "───────┴"center(''                                            , oWidth+10, '─')
      say;                return
