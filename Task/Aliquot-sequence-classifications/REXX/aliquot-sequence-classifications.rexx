/*REXX pgm classifies various positive integers for  aliquot sequences. */
parse arg low high L                            /*get optional arguments*/
high=word(high low 10,1);    low=word(low 1,1)  /*get the LOW and HIGH. */
if L=''  then L=11 12 28 496 220 1184 12496 1264460 790 909 562 1064 1488
big=2**47;                   NTlimit=16+1       /*limit: non-terminating*/
numeric digits max(9, 1+length(big))            /*be able to handle //  */
@.=.;  @.0=0;  @.1=0                            /*proper divisor sums.  */
say center('numbers from ' low " to " high, 79, "═")

     do n=low  to high                 /*process probably some low nums.*/
     call classify_aliquot  n          /*call subroutine to classify it.*/
     end   /*n*/                       /* [↑]   process a range of ints.*/
say
say center('first numbers for each classification', 79, "═")
b.=0                                   /* [↓]  ensure one of each class.*/
     do q=1  until b.sociable \== 0    /*only one that has to be counted*/
     call classify_aliquot  -q         /*the minus sign indicates ¬tell.*/
     b._=b._+1;  if b._==1  then call show_class q,$   /*show 1st found.*/
     end   /*q*/                       /* [↑]  until all classes found. */
say
say center('classifications for specific numbers', 79, "═")

     do i=1  for words(L)              /*L is a list of "special numbers*/
     call classify_aliquot  word(L,i)  /*call subroutine to classify it.*/
     end   /*i*/                       /* [↑]  process a list of numbers*/
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────CLASSIFY_ALIQUOT subroutine─────────*/
classify_aliquot: parse arg a 1 aa; a=abs(a)    /*get what # to be used.*/
if @.a\==.  then s=@.a                 /*Was number been summed before? */
            else s=SPdivs(a)           /*No, then do it the hard way.   */
@.a=s;  $=s                            /*define sum of the proper DIVs. */
what='terminating'                     /*assume this classification kind*/
c.=0;  c.s=1                           /*clear all cyclic seqs, set 1st.*/
if $==a then what='perfect'            /*check for "perfect" number.    */
        else do t=1  while  s\==0      /*loop until sum isn't 0 or >big.*/
             m=word($, words($))       /*obtain the last number in seq. */
             if @.m==.  then s=SPdivs(m)  /*if ¬defined, then sum Pdivs.*/
                        else s=@.m     /*use the previously found number*/
             if m==s & m\==0  then do;  what='aspiring'       ; leave; end
             if word($,2)==a  then do;  what='amicable'       ; leave; end
             $=$ s                     /*append a sum to number sequence*/
             if s==a & t>3    then do;  what='sociable'       ; leave; end
             if c.s  & m\==0  then do;  what='cyclic'         ; leave; end
             c.s=1                     /*assign another possible cyclic.*/
                                       /* [↓]  Rosetta Code's limit: >16*/
             if t>NTlimit     then do;  what='non-terminating'; leave; end
             if s>big         then do;  what='NON-TERMINATING'; leave; end
             end   /*t*/               /* [↑]  only permit within reason*/
if aa>0  then call show_class a,$      /*only display if  A is positive.*/
return
/*──────────────────────────────────SHOW_CLASS subroutine───────────────*/
show_class: say right(arg(1),digits()) 'is' center(what,15) arg(2); return
/*──────────────────────────────────SPDIVS subroutine───────────────────*/
SPdivs: procedure expose @.;  parse arg x;  if x<2 then return 0; odd=x//2
s=1                                    /* [↓] use only EVEN|ODD integers*/
   do j=2+odd  by 1+odd  while j*j<x   /*divide by all integers up to √x*/
   if x//j==0  then  s=s+j+ x%j        /*add the two divisors to the sum*/
   end   /*j*/                         /* [↑]  %  is REXX integer divide*/
                                       /* [↓] adjust for square.      _ */
if j*j==x  then  s=s+j                 /*Was X a square?  If so, add √x.*/
@.x=s                                  /*define the sum for the arg  X. */
return s                               /*return divisors  (both lists). */
