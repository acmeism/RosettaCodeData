/*REXX program executes a  Markov  algorithm(s)  against  specified entries.            */
parse arg low high .                             /*allows which  ruleset  to process.   */
if  low=='' |  low==","  then  low=1             /*Not specified?  Then use the default.*/
if high=='' | high==","  then high=6             /* "      "         "   "   "     "    */
tellE= low<0;          tellR= high<0             /*flags: used to display file contents.*/
call readEntry
               do j=abs(low)  to abs(high)       /*process each of these  rulesets.     */
               call readRules j                  /*read    a particular   ruleset.      */
               call execRules j                  /*execute "     "            "         */
               say 'result for ruleset'      j      "───►"      !.j
               end   /*j*/
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
execRules: parse arg q .;           if tellE | tellR  then say      /*show a blank line?*/
             do f=1
                do k=1  while @.k\=='';      if left(@.k, 1)=='#' | @.k=''  then iterate
                parse var  @.k   a   ' ->'    b  /*obtain the  A  &  B  parts from rule.*/
                a=strip(a);      b=strip(b)      /*strip leading and/or trailing blanks.*/
                fullstop= left(b, 1)==.          /*is this a  "fullstop"  rule?   1≡yes */
                if fullstop  then b=substr(b, 2) /*purify the  B  part of the rule.     */
                old=!.q                          /*remember the value before the change.*/
                !.q=changestr(a, !.q, b)         /*implement the  ruleset  change.      */
                if fullstop   then if old\==!.q  then return          /*should we stop? */
                if old\==!.q  then iterate f     /*Has Entry changed?   Then start over.*/
                end   /*k*/
              return
              end     /*f*/
           return
/*──────────────────────────────────────────────────────────────────────────────────────*/
readEntry: eFID= 'MARKOV.ENT';     if tellE  then say               /*show a blank line?*/
           !.=                                   /*placeholder for all the test entries.*/
                  do e=1  while lines(eFID)\==0  /*read the input file until End-Of-File*/
                  !.e=linein(eFID);  if tellE  then say 'test entry'    e    "───►"    !.e
                  end   /*e*/                    /* [↑]  read and maybe echo the entry. */
           return
/*──────────────────────────────────────────────────────────────────────────────────────*/
readRules: parse arg ? .;  rFID= 'MARKOV_R.'?;  if tellR  then say  /*show a blank line?*/
           @.=                                   /*placeholder for all the Markov rules.*/
                  do r=1  while lines(rFID)\==0  /*read the input file until End-Of-File*/
                  @.r=linein(rFID);  if tellR  then say 'ruleSet' ?"."left(r,4) '───►' @.r
                  end   /*r*/                    /* [↑]  read and maybe echo the rule.  */
           return
