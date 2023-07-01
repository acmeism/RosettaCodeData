/*REXX program  computes the   forward difference   of a  list of numbers.              */
numeric digits 100                               /*ensure enough accuracy (decimal digs)*/
parse arg e ',' N                                /*get a list:  ε1 ε2 ε3 ε4 ··· , order */
if e==''  then e=90 47 58 29 22 32 55 5 55 73    /*Not specified?  Then use the default.*/
#=words(e)                                       /*#  is the number of elements in list.*/
                                                 /* [↓]  verify list items are numeric. */
   do i=1  for #;        _=word(e, i)            /*process each number one at a time.   */
   if \datatype(_, 'N')  then call ser    _    "isn't a valid number";    @.i=_/1
   end   /*i*/                                   /* [↑]  removes superfluous stuff.     */
                                                 /* [↓]  process the optional order.    */
if N==''  then parse value 0 # # with bot top N  /*define the default  order  range.    */
          else parse var N bot 1 top             /*Not specified?  Then use only 1 order*/
if #==0   then call ser     "no numbers were specified."
if N<0    then call ser  N  "(order) can't be negative."
if N>#    then call ser  N  "(order) can't be greater than"  #
say right(#  'numbers:', 44)  e                  /*display the header (title)  and ···  */
say left('', 44)copies('─', length(e)+2)         /*display the header fence.            */
                                                 /* [↓]  where da rubber meets da road. */
      do o=bot  to top;        do r=1  for #;  !.r=@.r;     end /*r*/;        $=
        do j=1  for o; d=!.j;  do k=j+1  to #; parse value !.k !.k-d with d !.k; end /*k*/
        end   /*j*/
                               do i=o+1  to #; $=$ !.i/1;   end /*i*/
      if $==''  then $=' [null]'
      say right(o, 7)th(o)'─order forward difference vector ='     $
      end     /*o*/
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
ser:           say;           say '***error***';      say arg(1);     say;         exit 13
th: procedure; x=abs(arg(1)); return word('th st nd rd',1+x//10*(x//100%10\==1)*(x//10<4))
