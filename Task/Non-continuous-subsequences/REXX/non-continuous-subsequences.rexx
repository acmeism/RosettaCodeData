/*REXX program lists   non-continuous subsequences  (NCS),  given a sequence. */
parse arg list                               /*obtain the list from the C.L.  */
if list=''  then list=1 2 3 4 5              /*Not specified?  Use the default*/
say 'list=' space(list);     say             /*display the list to terminal.  */
w=words(list)          ;     #=0             /*W:  words in list;  # of NCS.  */
$=left(123456789,w)                          /*build a string of decimal digs.*/
tail=right($,max(0,w-2))                     /*construct a  "fast"  tail.     */

  do j=13  to left($,1) || tail              /*step through the list.         */
  if verify(j,$)\==0  then iterate           /*Not one of the chosen?         */
  f=left(j,1)                                /*use the 1st decimal digit of J.*/
  NCS=0                                      /*not non-continuous subsequence.*/
        do k=2 to length(j); _=substr(j,k,1) /*pick off a single decimal digit*/
        if _ <=  f    then iterate j         /*if next digit ≤,  then skip it.*/
        if _ \== f+1  then NCS=1             /*it's  OK  as of now.           */
        f=_                                  /*now have a new next decimal dig*/
        end   /*k*/

  if \NCS  then iterate                      /*not OK?  Then skip this number.*/
  #=#+1                                      /*Eureka!    We found onea digit.*/
  x=                                         /*the beginning of the  NCS.     */
        do m=1  for length(j)                /*build a sequence string to show*/
        x=x word(list,substr(j,m,1))         /*pick off a number to display.  */
        end   /*m*/

  say 'a non-continuous subsequence: '   x   /*show non─continous subsequence.*/
  end         /*j*/

if #==0  then #='no'                         /*make it more gooder Anglesh.   */
say;     say #   "non-continuous subsequence"s(#)    'were found.'
exit                                         /*stick a fork in it, we're done.*/
/*────────────────────────────────────────────────────────────────────────────*/
s:  if arg(1)==1 then return '';       return word(arg(2) 's',1)    /*plurals.*/
