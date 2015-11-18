/*REXX program to parse various queries on an XML document  (from a file).    */
iFID='XPATH.XML'                       /*name of the input  XML  file (doc).  */
$=                                     /*string will contain the file's text. */
     do j=1  while  lines(iFID)\==0    /*read the entire file into a string.  */
     $=$ linein(iFID)                  /*append the line to the  $  string.   */
     end   /*j*/
                                       /* [↓]  display 1st ITEM in document.  */
call parser 'item', 0                  /*go and parse the all the  ITEMs.     */
say center('first item:',@L.1,'─')     /*display a nicely formatted header.   */
say @.1;    say                        /*display the first  ITEM  found.      */

call parser 'price'                    /*go and parse all the   PRICEs.       */
say center('prices:',length(@@@),'─')  /*display a nicely formatted header.   */
say @@@;    say                        /*display a list of all the prices.    */

call parser 'name'
say center('names:',@L,'─')            /*display a nicely formatted header.   */
                        do k=1  for #  /*display all the names in the list.   */
                        say @.k        /*display a name from the  NAMES  list.*/
                        end   /*k*/
exit                                   /*stick a fork in it,  we're all done. */
/*────────────────────────────────────────────────────────────────────────────*/
parser:  parse arg yy,tail,,@. @@. @@@;   $$=$;  @L=9;  yb='<'yy;   ye='</'yy">"
tail=word(tail 1, 1)                                /*use a tail  ">"  or not?*/
      do #=1  until  $$=''                          /*parse complete XML doc. */
      if tail  then parse  var  $$  (yb) '>' @@.# (ye) $$         /*find meat.*/
               else parse  var  $$  (yb)     @@.# (ye) $$         /*  "    "  */
      @.#=space(@@.#);   @@@=space(@@@ @.#)         /*shrink;  @@@=list of YY.*/
      @L.#=length(@.#);  @L=max(@L,@L.#)            /*length; maximum length. */
      end   /*#*/
#=#-1                                               /*adjust # of thing found.*/
return
