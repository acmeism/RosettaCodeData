/*REXX pgm finds (dictionary) words which can be found in a specified word wheel (grid).*/
parse arg what iFID .                            /*obtain optional arguments from the CL*/
if what==''|what==","  then what= 'complition'   /*Not specified?  Then use the default.*/
if iFID==''|iFID==","  then iFID= 'UNIXDICT.TXT' /* "      "         "   "   "     "    */
@abc= 'abcdefghijklmnopqrstuvwxyz'               /*(Latin) lowercase letters to be used.*/
L= length(@abc)                                  /*   "      "    " the Latin letters.  */
wrds= 0                                          /*# words that are in the dictionary.  */
dups= 0                                          /*"   "     "   "  duplicates.         */
ills= 0                                          /*"   "     "   contain  "not" letters.*/
say '                                Reading the file: ' iFID         /*align the text. */
@.= .                                            /*non─duplicated dictionary words.     */
$=                                               /*the list of dictionary words in grid.*/
     do recs=0  while lines(iFID)\==0            /*process all words in the dictionary. */
     x= space( linein(iFID), 0)                  /*elide any blanks in the dictinary.   */
     if @.x\==.           then do; dups= dups+1; iterate; end  /*is this a duplicate?   */
     if \datatype(x,'M')  then do; ills= ills+1; iterate; end  /*has word non─letters?  */
     @.x=                                        /*signify that  X  is a dictionary word*/
     wrds= wrds + 1                              /*bump the number of "good" dist. words*/
     end   /*recs*/
a=
say '    number of  records (words) in the dictionary: '   right( commas(recs), 9)
say '    number of ill─formed words in the dictionary: '   right( commas(ills), 9)
say '    number of  duplicate words in the dictionary: '   right( commas(dups), 9)
say '    number of acceptable words in the dictionary: '   right( commas(wrds), 9)
say '    the  "word"  to be used for  text completion: '   what
say
call del what;  a= a result;        call del what,1;  a= a result
call ins what;  a= a result;        call ins what,1;  a= a result
call sub what;  a= a result;        call sub what,1;  a= a result
call prune
#= words($)
say commas(#) ' similar words found:'
       do j=1  for #;  _= word($, j);    say right( count(_,what), 24)  _
       end   /*j*/
exit #                                           /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
commas: parse arg _;  do ?=length(_)-3  to 1  by -3; _= insert(',', _, ?); end;   return _
prune:  do k=1  for words(a); _= word(a,k); if wordpos(_,$)==0  then $= $ _; end; return
recur:  $= $ del(z);          $= $ ins(z);           $= $ sub(z);                 return
/*──────────────────────────────────────────────────────────────────────────────────────*/
count: procedure; parse arg x,y;  cnt= 0;                            w= length(x)
         do j=1  for w;           p= pos( substr(x, j, 1), y);       if p==0  then iterate
         y= overlay(., y, p);     cnt= cnt + 1
         end   /*j*/
       return '     ' left("("format(cnt/w*100,,2)/1'%)', 9)     /*express as a percent.*/
/*──────────────────────────────────────────────────────────────────────────────────────*/
del:   procedure expose @. @abc L; parse arg y,r;      $=
         do j=1  for length(y);       z= space(left(y,j-1) ||           substr(y,j+1), 0)
         if @.z\==.  then $= $ z;     if r==1  then call recur
         end     /*j*/;               return space($)
/*──────────────────────────────────────────────────────────────────────────────────────*/
ins:   procedure expose @. @abc L; parse arg y,r;      $=
         do j=1  for length(y)
           do k=1  for L;   z= space(left(y,j-1) || substr(@abc,k,1) || substr(y,j),   0)
           if @.z\==.  then $= $ z;   if r==1  then call recur
           end   /*k*/
         end     /*j*/;               return space($)
/*──────────────────────────────────────────────────────────────────────────────────────*/
sub:   procedure expose @. @abc L; parse arg y,r;      $=
         do j=1  for length(y)
           do k=1  for L;   z= space(left(y,j-1) || substr(@abc,k,1) || substr(y,j+1), 0)
           if @.z\==.  then $= $ z;   if r==1  then call recur
           end   /*k*/
         end     /*j*/;               return space($)
