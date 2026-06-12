/*REXX program produces a Markov chain text from a training text using a text generator.*/
parse arg ord fin iFID seed .                    /*obtain optional arguments from the CL*/
if  ord=='' | ord==","  then ord=   3            /*Not specified?  Then use the default.*/
if  fin=='' | fin==","  then fin= 300            /* "      "         "   "   "     "    */
if iFID=='' |iFID==","  then iFID='alice_oz.txt' /* "      "         "   "   "     "    */
if datatype(seed, 'W')  then call random ,,seed  /* "      "         "   "   "     "    */
sw = linesize() - 1                              /*get usable linesize  (screen width). */
$= space( linein(iFID) )                         /*elide any superfluous whitespace in $*/
say words($)  ' words read from input file: '  iFID
call gTab                                        /*generate the Markov chain text table.*/
call gTxt                                        /*generate the Markov chain text.      */
call show                                        /*display formatted output and a title.*/
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
gTab: @.=;   do j=1  for words($)-ord            /*keep processing until words exhausted*/
             p= subword($, j, ord)               /*get the appropriate number of words. */
             @.p= @.p  word($, j + ord)          /*get a prefix & 1 (of sev.?) suffixes.*/
             end   /*j*/
      #= j-1                                     /*define the number of prefixes.       */
      return
/*──────────────────────────────────────────────────────────────────────────────────────*/
gTxt: mc=;   do  until words(mc)>=fin            /*build Markov chain text until enough.*/
             y= subword($, random(1, #), ord)    /*obtain appropriate number of words.  */
             s= @.y;      w= words(s)            /*get a suffix for a word set; # wprds.*/
             if w>1  then s= word(s,random(1,w)) /*pick random word in the set of words.*/
             mc= mc y s                          /*add a prefix and suffix to the output*/
             end   /*until*/
      return
/*──────────────────────────────────────────────────────────────────────────────────────*/
show: say center('Markov chain text', sw, "═")   /*display the title for the output.    */
      g= word(mc, 1)                             /*generate lines of Markov chain text. */
             do k=2  to words(mc)                /*build output lines word by word.     */
             _= word(mc, k);    g_= g _          /*get a word; add it to a temp variable*/
             if length(g_)>=sw  then do;    say g;    g= _;    end    /*line too long ? */
                                else g= g_                            /*line OK so far. */
             end   /*k*/
      if g\==''  then say g                      /*There any residual?  Then display it.*/
      return                                     /* [↑]  limits   G   to terminal width.*/
