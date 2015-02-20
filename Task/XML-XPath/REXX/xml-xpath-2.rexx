/*REXX program to parse various queries on an XML document (from a file)*/
iFID='XPATH.XML'                       /*name of the input XML file(doc)*/
$=                                     /*string will contain file's text*/
      do j=1  while  lines(iFID)\==0   /*read the entire file into a str*/
      $=$ linein(iFID)                 /*append the line to the $ string*/
      end   /*j*/

call parser 'item', 0                  /*go and parse the all   ITEMs.  */
say center('first item:',@L.1,'─')     /*show a nicely formatted header.*/
say @.1                                /*show the first  ITEM  found.   */
say

call parser 'price'                    /*go and parse all the   PRICEs. */
say center('prices:',length(@@@),'─')  /*show a nicely formatted header.*/
say @@@                                /*show a list of all the prices. */
say

call parser 'name'
say center('names:',@L,'─')            /*show a nicely formatted header.*/
                  do k=1  for #        /*show all the names in the list.*/
                  say @.k              /*show a name from the NAMES list*/
                  end   /*k*/
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────PARSER subroutine───────────────────*/
parser:  parse arg yy,tail,,@. @@. @@@; $$=$; @L=9; yb='<'yy; ye='</'yy">"
tail=word(tail 1, 1)                            /*use a tail ">" or not?*/
      do #=1  until  $$=''                      /*parse complete XML doc*/
      if tail  then parse  var  $$  (yb) '>' @@.# (ye) $$    /*find meat*/
               else parse  var  $$  (yb)     @@.# (ye) $$    /*  "    " */
      @.#=space(@@.#);   @@@=space(@@@ @.#)     /*shrink; @@@=list of YY*/
      @L.#=length(@.#);  @L=max(@L,@L.#)        /*YY length, max length.*/
      end   /*#*/
#=#-1                                           /*adjust # things found.*/
return
