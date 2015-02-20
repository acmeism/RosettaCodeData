/*REXX program counts the number of textonyms are in a file (dictionary)*/
parse arg iFID .                       /*get optional fileID of the file*/
if iFID==''  then iFID='UNIXDICT.TXT'  /*filename of the word dictionary*/
@.=0                                   /*digit combinations placeholder.*/
!.=;  $.=                              /*sparse array of textonyms;words*/
alphabet='ABCDEFGHIJKLMNOPQRSTUVWXYZ'  /*supported alphabet to be used. */
digitKey= 22233344455566677778889999   /*translated alphabet to dig key.*/
digKey=0;          wordCount=0         /*# digit combinations; wordCount*/
ills=0;   dups=0;  longest=0; mostus=0 /*illegals; duplicate words; lit.*/
first=0;  last=0;  long=0;    most=0   /*for: first, last, longest, ··· */
call linein  iFID, 1, 0                /*point to the first char in dict*/
#=0                                    /*number of textonyms in the file*/
                                       /* [↑]   ───in case file is open.*/
  do j=1  while lines(iFID)\==0        /*keep reading until exhausted.  */
  x=linein(iFID);   y=x;    upper x    /*get a word  and  uppercase it. */
  if \datatype(x,'U')  then do; ills=ills+1; iterate; end   /*illegal?  */
  if $.x\==''          then do; dups=dups+1; iterate; end   /*duplicate?*/
                       else $.x=.      /*indicate it's a righteous word.*/
  wordCount=wordCount+1                /*bump the word count (for file).*/
  z=translate(x, digitKey, alphabet)   /*build translated digit key word*/
  @.z=@.z+1                            /*flag the digit key word exists.*/
  !.z=!.z y;      _=words(!.z)         /*build a list of same digit key.*/
  if _>most  then do;  mostus=z; most=_; end  /*remember mostus digKeys.*/
  if @.z==2  then do;  #=#+1           /*bump the count of the textonyms*/
                  if first==0   then first=z  /*the first textonym found*/
                  last=z                      /* "   last     "      "  */
                  _=length(!.z)               /*length of the digit key.*/
                  if _>longest  then long=z   /*is this the longest ?   */
                  longest=max(_, longest)     /*now, shoot for this len.*/
                  end                         /* [↑] discretionary stuff*/
  if @.z\==1  then iterate             /*Does it already exist?  Skip it*/
  digKey=digKey+1                      /*bump count of digit key words. */
  end     /*j*/
                  @@=' which can be represented by the digit key mapping.'
say wordCount   'is the number of words in file  "'iFID'"'   @@
if ills\==0   then say ills 'word's(ills) "contained illegal characters."
if dups\==0   then say dups "duplicate word"s(dups)  'detected.'
say 'They require'  digKey   "combination"s(digKey)   'to represent them.'
say #  'digit combination's(#)   "represent Textonyms."
say
if first\==0  then say  '    first digit key='  !.first
if  last\==0  then say  '     last digit key='  !.last
if  long\==0  then say  '  longest digit key='  !.long
if  most\==0  then say  ' numerous digit key='  !.mostus ' ('most "words)"
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────S subroutine────────────────────────*/
s: if arg(1)==1  then return '';     return 's'   /*a simple pluralizer.*/
