/*REXX program finds some  non─null subsets  of a  weighted list  whose  sum eqals zero.*/
parse arg  target stopAt chunkette .             /*option optional arguments from the CL*/
if target=='' | target==","  then target= 0      /*Not specified?  Then use the default.*/
if stopAt=='' | stopAt==","  then stopAt= 1      /* "      "         "   "   "     "    */
y= 0
zz= 'archbishop -915   covariate 590   mycenae  183   brute   870   balm  397  fiat 170' ,
    'smokescreen 423   eradicate 376   efferent  54   bonnet  452   vein  813          ' ,
    'diophantine 645   departure 952   lindholm 999   moresby 756   isis -982          ' ,
    'mincemeat  -880   alliance -624   flatworm 503   elysee -326   cobol 362          ' ,
    'centipede  -658   exorcism -983   gestapo  915   filmy  -874   deploy 44          ' ,
    'speakeasy  -745   plugging -266   markham  475   infra  -847   escritoire  856    '
@.= 0
                do N=1  until zz=''              /*construct an array from the ZZ list. */
                parse var  zz   @.N  #.N  zz     /*pick from the list like a nose.      */
                end   /*N*/
call eSort N                                     /*sort the names with weights.         */
call tellZ  'sorted'                             /*display the sorted list.             */
chunkStart= 1                                    /*the default place to  start.         */
chunkEnd  = N                                    /* "     "      "    "   end.          */
if chunkette\==''  then do                       /*solutions just for a chunkette.      */
                        chunkStart= chunkette
                        chunkEnd  = chunkette
                        end
call time 'Reset'                                /*reset the REXX elapsed time.         */
??= 0                                            /*the number of solutions  (so far).   */
      do chunk=chunkStart  to chunkEnd           /*traipse through the items.           */
      call tello center(' doing chunk:'   chunk" ", 79, '─')
      call combN N, chunk                        /*N  items,   a  CHUNK  at a time.     */
      _= ??                                      /*set a temporary variable to    ??.   */
      if _==0  then _= 'No'                      /*Englishise    _   for a zero count.  */
      call tello _  'solution's(??)     "found so far."
      end   /*chunk*/

if ??==0  then ??= 'no'                          /*Englishise the solutions number.     */
call tello   'Found'    ??    "subset"s(??)    'whose summed weight's(??)    "="    target
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
combN: procedure expose @. #. ?? stopAt target;       parse arg x,y;        !.= @.0
       base= x + 1;      bbase= base - y         /*!.n   are the combination digits.    */
         do n=1  for y;  !.n=n                   /*construct the first combination.     */
         end   /*n*/
       ym= y - 1
         do j=1;         _= !.1;      s= #._     /*obtain the first digit and the sum.  */
         if s>target  then leave                 /*Is  1st dig>target?  Then we're done.*/
           do k=2  for ym;   _= !.k;  s= s + #._ /*Σ the weights;  is sum > target ?    */
           if s>target  then do;      if .combUp(k-1)  then return;    iterate j;    end
           end   /*k*/
         if s==target  then call telly           /*have we found a pot of gold?         */
         !.y= !.y + 1;  if !.y==base  then  if .combUp(ym)  then leave    /*bump digit.*/
         end      /*j*/;              return     /*done with this combination set.      */
/*──────────────────────────────────────────────────────────────────────────────────────*/
.combUp: procedure expose !. y bbase; parse arg d;           if d==0  then return 1
         p= !.d;   do u=d  to y;      !.u= p + 1 /*add one to digit we're pointing at.  */
                   if !.u >= bbase+u  then return .combUp(u-1)
                   p= !.u                        /*P   will be used for the next digt.  */
                   end   /*u*/;       return 0   /*go back and sum this combination.    */
/*──────────────────────────────────────────────────────────────────────────────────────*/
eSort: procedure expose #. @. $.;          parse arg N,$;              h= N
         do  while h>1;                    h= h % 2
           do i=1  for  N-h;     j= i;     k= h + i
           if $==. then do while $.k<$.j;  parse value $.j $.k         with $.k $.j
                        if h>=j  then leave;     j= j - h;             k= k - h
                        end   /*while $.k<$.j*/
                   else do while #.k<#.j; parse value @.j @.k #.j #.k with @.k @.j #.k #.j
                        if h>=j  then leave;     j= j - h;             k= k - h
                        end   /*while #.k<#.j*/
           end   /*i*/
         end     /*while h>1*/;            return
/*──────────────────────────────────────────────────────────────────────────────────────*/
s:     if arg(1)==1  then return arg(3);  return word(arg(2) 's', 1) /*simple pluralizer*/
tello: parse arg _,e;  if e==.  then say;  say _;  call lineout 'SUBSET.'y, _;      return
/*──────────────────────────────────────────────────────────────────────────────────────*/
telly: ??= ?? + 1;                     nameL=    /*start with a  "null"  name list.     */
                     do gi=1  for y;   ggg= !.gi /*build duplicate array (to be sorted).*/
                     $.gi= @.ggg                 /*transform from  index ──►  a name.   */
                     end   /*gi*/                /*build duplicate array (to be sorted).*/
       call eSort y, .                           /*sort the names alphabetically.       */
         do gs=1  for y;   nameL= nameL $.gs     /*build a list of names whose  sum = 0 */
         end   /*gs*/                            /*the list of names could be sorted.   */
       call tello  '['y"   name"s(y)']'      space(nameL)
       if ??<stopAt | stopAt==0  then return     /*see if we reached a  (or the)  limit.*/
       call tello 'Stopped after finding '   ??   " subset"s(??)'.', .
       exit                                      /*a short─timer,  we should quit then. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
tellz:             do j=1  for N                 /*show a list of names and weights.    */
                   call tello  right('['j']', 30)       right(@.j, 11)       right(#.j, 5)
                   end   /*j*/
       call tello
       call tello    'There are  '     N     " entries in the (above)"   arg(1)   'table.'
       call tello;                    return
