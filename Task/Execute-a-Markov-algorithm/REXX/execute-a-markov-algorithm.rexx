/*REXX pgm to execute a  Markov  algorithm(s) against specified entries.*/
parse arg low high .                   /*allow which ruleset to process.*/
if  low=='' |  low==','  then  low=1   /*assume a default if none given.*/
if high=='' | high==','  then high=6   /*assume a default if none given.*/
tellE = low<0;   tellR = high<0        /*flags: display file contents.  */
call readEntry
       do j=abs(low)  to abs(high)     /*process each of these rulesets.*/
       call readRules j                /*read    a particular ruleset.  */
       call execRules j                /*execute "     "         "      */
       say 'result for ruleset' j"≡"!.j
       end   /*j*/
exit                                   /*stick a fork in it, we're done.*/
/*───────────────────────────────EXECRULES──────────────────────────────*/
execRules: parse arg q .;               if tellE | tellR  then say
     do f=1  /* forever  */
        do k=1  while @.k\==''; if left(@.k,1)=='#' | @.k=''  then iterate
        parse var  @.k   a  ' ->'   b;         a=strip(a);    b=strip(b)
        fullstop= left(b,1)=='.'       /*is this a fullstop rule?       */
        if fullstop then b=substr(b,2) /*purify the B part of the rule. */
        old=!.q                        /*remember value before change.  */
        !.q=changestr(a, !.q, b)       /*implement the ruleset change.  */
        if fullstop   then  if old\==!.q  then return  /*should we stop?*/
        if old\==!.q  then iterate f   /*Entry changed?  Then start over*/
        end   /*k*/
      leave
      end     /*f*/
return
/*───────────────────────────────READRULES──────────────────────────────*/
readRules: parse arg ? .;       rFID='MARKOV_R.'?;     if tellR  then say
@.=                                    /*placeholder:  all Markov rules.*/
        do r=1  while lines(rFID)\==0  /*read the input file until E-O-F*/
        @.r=linein(rFID);  if tellR then say 'ruleSet' ?"."left(r,4)'≡'@.r
        end   /*r*/                    /*(above) read and maybe echo it.*/
return
/*───────────────────────────────READENTRY──────────────────────────────*/
readEntry:                       eFID='MARKOV.ENT';    if tellE  then say
!.=                                    /*placeholder:  all test entries.*/
        do e=1  while lines(eFID)\==0  /*read the input file until E-O-F*/
        !.e=linein(eFID);  if tellE  then say 'test entry' e"≡"!.e
        end   /*e*/                    /*(above) read and maybe echo it.*/
return
