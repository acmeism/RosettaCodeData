/*REXX program displays (a range of)  ludic numbers, or a count of when a range is used.*/
parse arg N count bot top triples .              /*obtain optional arguments from the CL*/
if       N=='' |       N=="," then       N=25    /*Not specified?  Then use the default.*/
if   count=='' |   count=="," then   count=1000  /* "      "         "   "   "     "    */
if     bot=='' |     bot=="," then     bot=2000  /* "      "         "   "   "     "    */
if     top=='' |     top=="," then     top=2005  /* "      "         "   "   "     "    */
if triples=='' | triples=="," then triples=250-1 /* "      "         "   "   "     "    */
$=ludic( max(N, count, bot, top, triples) )                /*generate enough ludic nums.*/
say 'The first '  N  " ludic numbers: "  subword($,1,25)   /*display 1st  N  ludic nums.*/
            do j=1  until word($, j) > count;   end        /*process up to a specific #.*/
say
say "There are "        j-1         ' ludic numbers that are  ≤ '          count
say
say "The "  bot  '───►'     top     ' (inclusive)  ludic numbers are: '    subword($, bot)
#=0
@=;  do j=1  for words($);          _=word($,j)  /*it is known that ludic   _   exists. */
     if _>=triples  then leave                   /*only process up to a specific number.*/
     if wordpos(_+2, $)==0  |  wordpos(_+6, $)==0  then iterate  /*Not triple?  Skip it.*/
     #=#+1;             @=@ '◄'_  _+2  _+6"► "   /*bump the triple counter,  and  ···   */
     end   /*j*/                                 /* [↑]  append the found triple ──►  @ */
say
if @==''  then  say  'From 1──►'triples", no triples found."
          else  say  'From 1──►'triples", "     #     ' triples found:'      @
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
ludic: procedure; parse arg m,,@;    $=1 2       /*$≡ludic numbers superset;  @≡sequence*/
            do j=3  by 2  to  m*15;  @=@ j;  end /*construct an initial list of numbers.*/
       @=@' ';                       n=words(@)  /*append a blank to the number sequence*/
            do  while n\==0;  f=word(@,1); $=$ f /*examine the first word in @; add to $*/
                  do d=1  by f while d<=n; n=n-1 /*use 1st number, elide all occurrences*/
                  @=changestr(' 'word(@, d)" ",  @,  ' . ')   /*crossout a number in  @ */
                  end   /*d*/                    /* [↑]  done eliding the "1st" number. */
            @=translate(@, , .)                  /*change dots to blanks; count numbers.*/
            end        /*while*/                 /* [↑]  done eliding ludic numbers.    */
       return subword($, 1, m)                   /*return a  range  of  ludic  numbers. */
