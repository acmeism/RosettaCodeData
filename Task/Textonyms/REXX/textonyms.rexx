/*REXX program counts and displays the number of textonyms that are in a dictionary file*/
parse arg iFID .                                 /*obtain optional fileID from the C.L. */
if iFID=='' | iFID=="," then iFID='UNIXDICT.TXT' /*Not specified?  Then use the default.*/
@.=0                                             /*the placeholder of digit combinations*/
!.=;  $.=                                        /*sparse array of textonyms;  words.   */
alphabet= 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'           /*the supported alphabet to be used.   */
digitKey=  22233344455566677778889999            /*translated alphabet to digit keys.   */
digKey=0;            wordCount=0                 /*number digit combinations; wordCount.*/
ills=0;    dups=0;   longest=0;  mostus=0        /*illegals; duplicated words; longest..*/
first=.;   last=.;   long=0;     most=0          /*first, last, longest, most counts.   */
#=0                                              /*number of textonyms in file (so far).*/
call linein  iFID, 1, 0                          /*point to the first char in dictionary*/    /* ◄■■■■■ optional.*/

  do  while  lines(iFID)\==0                     /*keep reading the file until exhausted*/
          x=linein(iFID);   y=x;      upper x    /*get a word; save a copy; uppercase it*/
  if \datatype(x,'U')  then do;  ills=ills + 1;  iterate;  end       /*Not legal?  Skip.*/
  if $.x==.            then do;  dups=dups + 1;  iterate;  end       /*Duplicate?  Skip.*/
  $.x=.                                          /*indicate that it's a righteous word. */
  wordCount=wordCount + 1                        /*bump the word count  (for the file). */
  z=translate(x, digitKey, alphabet)             /*build a translated digit key word.   */
  @.z=@.z + 1                                    /*flag that the digit key word exists. */
  !.z=!.z  y;         _=words(!.z)               /*build list of equivalent digit key(s)*/

  if _>most  then do; mostus=z;  most=_;  end    /*remember the  "mostus"  digit keys.  */

  if @.z==2  then do; #=# + 1                    /*bump the count of the  textonyms.    */
                      if first==.   then first=z /*the first textonym found.            */
                      last=z                     /* "   last     "      "               */
                      _=length(!.z)              /*the length (# chars) of the digit key*/
                      if _>longest  then long=z  /*is this the  longest  textonym ?     */
                      longest=max(_, longest)    /*now, use this length as a target/goal*/
                  end                            /* [↑]  discretionary  (extra credit). */

  if @.z==1  then digKey=digKey + 1              /*bump the count of digit key words.   */
  end   /*while*/
                        @whichCan...=    'which can be represented by digit key mapping.'
                        @Ta         =    'There are '
say 'The dictionary file being used is: '        iFID
say                     @Ta wordCount    ' words in the file'      @whichCan...
if ills\==0   then say  @Ta ills         ' word's(ills)    "contained illegal characters."
if dups\==0   then say  @Ta dups   " duplicate word"s(dups)  'in the dictionary detected.'
say 'The textonyms require '    digKey   " combination"s(digKey)   'to represent them.'
say @Ta   #   ' digit combination's(#)   " that can represent Textonyms."
say
if first\==.  then say  '    first digit key='   !.first
if  last\==.  then say  '     last digit key='   !.last
if  long\==0  then say  '  longest digit key='   !.long
if  most\==0  then say  ' numerous digit key='   !.mostus       ' ('most     "words)"
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
s:  if arg(1)==1  then return '';         return "s"              /*a simple pluralizer.*/
