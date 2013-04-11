/*REXX program  evaluates  a  Reverse Polish notation (RPN)  expression.*/
parse arg x;    if x=''  then x = '3 4 2 * 1 5 - 2 3 ^ ^ / +';        ox=x
showSteps=1               /*set to 0 (zero) if working steps not wanted.*/
x=space(x);    tokens=words(x)
  do i=1  for tokens;  @.i=word(x,i);  end /*i*/   /*assign input tokens*/
L=max(20,length(x))                    /*use 20 for the min show width. */
numeric digits L                       /*ensure enough digits for answer*/
say center('operand',L,'─') center('stack',L*2,'─');     e='***error!***'
op='- + / * ^';             add2s='add to───►stack';     z=;       stack=

  do #=1  for tokens;   ?=@.#;   ??=?  /*process each token from @. list*/
  w=words(stack)                              /*stack count (# entries).*/
  if datatype(?,'N') then do; stack=stack ?; call show add2s; iterate; end
  if ?=='^'          then ??="**"      /*REXXify  ^ ──► **  (make legal)*/
  interpret 'y=' word(stack,w-1) ?? word(stack,w)             /*compute.*/
  if datatype(y,'W') then y=y/1        /*normalize the number with  ÷   */
  _=subword(stack,1,w-2);   stack=_ y  /*rebuild the stack with answer. */
  call show ?
  end   /*#*/

z=space(z stack)                       /*append any residual entries.   */
say;  say ' RPN input:'  ox;    say '  answer──►' z  /*show input & ans.*/
parse source upper . y .               /*invoked via  C.L.  or REXX pgm?*/
if y=='COMMAND' | \datatype(z,'W') then exit /*stick a fork in it, done.*/
                                   else return z   /*RESULT ──► invoker.*/
/*──────────────────────────────────SHOW subroutine─────────────────────*/
show: if showSteps then say center(arg(1),L) left(space(stack),L);  return
