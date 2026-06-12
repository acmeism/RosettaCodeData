/*REXX pgm examines the birthday problem via random# simulation (with specifiable parms)*/
parse arg dups samp seed .                       /*get optional arguments from the CL.  */
if dups=='' | dups==","  then dups=    10        /*Not specified?  Then use the default.*/
if samp=='' | samp==","  then samp= 10000        /* "      "         "   "   "     "    */
if datatype(seed, 'W')   then call random ,,seed /*RANDOM seed given for repeatability ?*/
diy = 365         /*alternative: diy=365.25*/    /*the number of    Days In a Year.     */
diyM= diy*100                                    /*this expands the RANDOM  (BIF) range.*/
             do   g=2  to dups;      s= 0        /*perform through  2 ──► duplicate size*/
               do  samp;            @.= 0        /*perform some number of trials.       */
                      do j=0  until @.day==g     /*perform until G dup. birthdays found.*/
                      day= random(1, diyM) % 100 /*expand range RANDOM number generation*/
                      @.day= @.day + 1           /*record the number of common birthdays*/
                      end   /*j*/                /* [↓]  adjust for the  DO  loop index.*/
               s= s+j                            /*add number of birthday hits to sum.  */
               end          /*samp*/             /* [↓]  % 1   rounds down the division.*/
             start.g= s/samp % 1  -  g           /*define where the  try─outs  start.   */
             end            /*g*/                /* [↑]  get a rough estimate for %.    */
say right('sample size is '   samp, 40);   say   /*display this run's sample size.      */
say '          required         trial       %  with required'
say '         duplicates         size       common birthdays'
say '        ────────────      ───────     ──────────────────'
   do   g=2  to dups                             /*perform through  2 ──► duplicate size*/
     do try=start.g  until s/samp>=.5;     s= 0  /*   "    try─outs until average ≥ 50%.*/
       do samp;                           @.= 0  /*   "    some number of trials.       */
         do try;     day= random(1, diyM) % 100  /*   "    until G dup. birthdays found.*/
         @.day= @.day + 1                        /*record the number of common birthdays*/
         if @.day==g  then do; s=s+1; leave; end /*found enough  G  (birthday)  hits ?  */
         end   /*try;*/
       end     /*samp*/
     end       /*try=start.g*/                   /* [↑]  where the  try─outs  happen.   */
   say right(g, 15)     right(try, 15)      center( format( s / samp * 100, , 4)'%',  30)
   end         /*g*/                             /*stick a fork in it,  we're all done. */
