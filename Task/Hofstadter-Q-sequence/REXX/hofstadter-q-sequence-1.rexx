/*REXX program generates the    Hofstadter  Q     sequence for any specified   N.       */
parse arg a b c d .                              /*obtain optional arguments from the CL*/
if a=='' | a==","  then a=       10              /*Not specified?  Then use the default.*/
if b=='' | b==","  then b=    -1000              /* "      "         "   "   "      "   */
if c=='' | c==","  then c=  -100000              /* "      "         "   "   "      "   */
if d=='' | d==","  then d= -1000000              /* "      "         "   "   "      "   */
@.= 1;                 ac=   abs(c)              /* [↑]  negative #'s don't show values.*/
call HofstadterQ  a;   say
call HofstadterQ  b;   say 'HofstadterQ '  commas(abs(b))th(b) " term is: " commas(result)
call HofstadterQ  c;   say
downs= 0;                         do j=2  for ac-1;     jm= j - 1
                                  downs= downs + (@.j<@.jm)
                                  end   /*j*/

say commas(downs)    ' HofstatdterQ terms are less then the previous term,' ,
                     ' HofstatdterQ('commas(ac)  ||  th(ac)")  term is: "     commas(@.ac)
call HofstadterQ  d;                                             ad= abs(d);           say
say 'The '   commas(ad) || th(ad)    ' HofstatdterQ term is: '       commas(@.ad)
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
HofstadterQ: procedure expose @.; parse arg x 1 ox     /*get number to generate through.*/
                                                       /* [↑]   OX    is the same as X. */
x= abs(x);                    w= length( commas(x) )   /*use absolute value; get length.*/
           do j=1  for x                               /* [↓]  use short─circuit IF test*/
           if j>2   then if @.j==1  then  do;    jm1= j - 1;             jm2= j - 2
                                                 one= j - @.jm1;         two= j - @.jm2
                                                 @.j= @.one  +  @.two
                                          end
           if ox>0  then say 'HofstadterQ('right(j, w)"): "  right(@.j,max(w,length(@.j)))
           end    /*j*/
return @.x                                             /*return the │X│th term to caller*/
/*──────────────────────────────────────────────────────────────────────────────────────*/
commas:  parse arg _;  do ?=length(_)-3  to 1  by -3; _=insert(',', _, ?); end;   return _
th: procedure; #=abs(arg(1)); return word('th st nd rd',1+#//10*(#//100%10\==1)*(#//10<4))
