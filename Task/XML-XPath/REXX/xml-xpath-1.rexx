/*REXX program to parse various queries on an XML document  (from a file).    */
iFID='XPATH.XML'                       /*name of the input  XML  file (doc).  */
$=                                     /*string will contain the file's text. */
     do j=1  while  lines(iFID)\==0    /*read the entire file into a string.  */
     $=$ linein(iFID)                  /*append the line to the  $  string.   */
     end   /*j*/
                                       /* [↓]  show 1st  ITEM  in the document*/
parse var $  '<item '  item  "</item>"
say center('first item:',length(space(item)),'─')     /*display a nice header.*/
say space(item)
                                       /* [↓]  show all PRICES in the document*/
prices=                                /*nullify the list and add/append to it*/
$$=$                                   /*start with a fresh copy of document. */
     do  until $$=''                   /* [↓]  keep parsing string until done.*/
     parse var $$  '<price>'   price   '</price>' $$
     prices=prices price               /*add/append the price to the list.    */
     end   /*until*/
say
say center('prices:',length(space(prices)),'─')       /*display a nice header.*/
say space(prices)
                                       /* [↓]  show all  NAMES in the document*/
names.=                                /*nullify the list and add/append to it*/
L=length(' names: ')                   /*maximum length of any one list name. */
$$=$                                   /*start with a fresh copy of document. */
     do #=1  until $$=''               /* [↓]  keep parsing string until done.*/
     parse var $$  '<name>'   names.#   '</name>'   $$
     L=max(L,length(names.#))          /*L:  is used to find the widest name. */
     end   /*#*/

names.0=#-1;                  say      /*adjust the number of names (DO loop).*/
say center('names:',L,'─')             /*display a nicely formatted header.   */
     do k=1  for names.0               /*display all the names in the list.   */
     say names.k                       /*display a name from the  NAMES  list.*/
     end   /*k*/
                                       /*stick a fork in it,  we're all done. */
