/*REXX pgm finds and displays bare language (<lang>) tags without a language specified. */
parse arg iFID .                                 /*obtain optional argument from the CL.*/
if iFID=='' | iFID=","  then iFID= 'BARELANG.HTM'  /*Not specified?  Then assume default*/
call lineout iFID                                /*close the file, just in case its open*/
call linein  ifid,1,0                            /*point to the first record.           */
noLa= 0;  bare= 0;  header=;  heads=             /*initialize various REXX variables.   */
!.= 0                                            /*sparse array to hold language headers*/
            do recs=0  while lines(iFID)\==0     /*read all lines in the input file.    */
            $= linein(iFID)                      /*read a line (record) from the input. */
            $= space($)                          /*elide superfluous blanks from record.*/
            if $==''  then iterate               /*if a blank line, then skip any tests.*/
            call testHead                        /*process possible  ==((header|aaa}}== */
            call testLang                        /*   "        "    <lang aaa> or <lang>*/
            end   /*recs*/

call lineout iFID                                /*close the file, just in case its open*/
say recs  ' records read from file: '  iFID; say /*show number of records read from file*/
if bare==0  then bare= 'no';    say right(bare, 9)   " bare language tags.";           say

   do #=1  for words(head);   _= word(head, #)   /*maybe show  <lang>  for language aaa */
   if !._\==0  then say right(!._, 9)  ' in'  _  /*show the count for a particular lang.*/
   end   /*#*/

if noLa==0  then noLa= 'no';    say right(noLa, 9)   " in no specified language."
exit 0
/*--------------------------------------------------------------------------------------*/
testHead: @head= '=={{header|';      @foot= "}}=="               /*define two literals. */
          hh= pos(@head, $     );    if hh==0  then return       /*get start of literal.*/
          or= hh + length(@head) - 1                             /*get position of  |   */
          hb= pos(@foot, $, or);     if hb==0  then return       /*get position of foot.*/
          head= substr($, or+1, hb-or-1)                         /*get the language name*/
          if head\==''  then header= head                        /*Header?  Then use it.*/
          if wordpos(head, heads)==0  then heads= heads head     /*Is lang?  Add--? list*/
          return
/*--------------------------------------------------------------------------------------*/
testLang: @lang= '<lang';            @back= ">"                  /*define two literals. */
          s1= pos(@lang, $      );   if s1==0  then return       /*get start of literal.*/
          gt= pos(@back, $, s1+1)                                /*get position of  <   */
          lang= strip( substr($, gt-2, gt-length(@lang) -1 ) )   /*get the language name*/
          if lang==''  then bare= bare + 1                       /*No lang?  Bump bares.*/
                       else @lang= lang                          /*Is lang?  Set lang.  */
          if @lang\==''  &  header==''   then noLa= noLa + 1     /*bump  noLang counter.*/
          if @lang\==''  &  header\==''  then !.head= !.head + 1 /*bump  a lang    "    */
          return
