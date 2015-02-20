/*REXX program to parse various queries on an XML document (from a file)*/
iFID='XPATH.XML'                       /*name of the input XML file(doc)*/
$=                                     /*string will contain file's text*/
     do j=1  while lines(iFID)\==0     /*read the entire file into a str*/
     $=$ linein(iFID)                  /*append the line to the $ string*/
     end   /*j*/
                                       /* [↓] show 1st  ITEM  in the doc*/
parse var $ '<item ' item  "</item>"
say center('first item:',length(space(item)),'─')   /*show a nice header*/
say space(item)
                                       /* [↓] show all PRICES in the doc*/
prices=                                /*nullify the list and add to it.*/
$$=$                                   /*start with a fresh copy of doc.*/
     do  until $$=''                   /* [↓]  keep parsing until done. */
     parse var $$ '<price>' price '</price>' $$
     prices=prices price               /*added the price to the list.   */
     end   /*until*/
say
say center('prices:',length(space(prices)),'─')     /*show a nice header*/
say space(prices)
                                       /* [↓] show all  NAMES in the doc*/
names.=                                /*nullify the list and add to it.*/
L=length(' names: ')                   /*maximum length of any one name.*/
$$=$                                   /*start with a fresh copy of doc.*/
     do #=1  until $$=''               /* [↓]  keep parsing until done. */
     parse var $$ '<name>' names.# '</name>' $$
     L=max(L,length(names.#))          /*used to find the widest name.  */
     end   /*#*/

names.0=#-1                            /*adjust the # of names (DO loop)*/
say
say center('names:',L,'─')             /*show a nicely formatted header.*/
     do k=1  for names.0               /*show all the names in the list.*/
     say names.k                       /*show a name from the NAMES list*/
     end   /*k*/
exit                                   /*stick a fork in it, we're done.*/
