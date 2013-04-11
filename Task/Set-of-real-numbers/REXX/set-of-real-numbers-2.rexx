/*REXX pgm demonstrates a way to represent any set of real #s and usage.*/
call set_query ,   ,  '(0,1]   union   [0,2)'
call set_query ,   ,  '[0,2)     ∩     (1,3)'
call set_query ,   ,  '[0,3]     -     (0,1)'
call set_query ,   ,  '[0,3]     -     [0,1]'
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────SET_BAD subroutine─────────-────────*/
set_bad: say;  say  '***error!*** bad format of SET_def: ('arg(1)")"; exit
/*──────────────────────────────────SET_empty subroutine────────────────*/
set_empty:   parse arg _;       nam=set_val(_,00);      return @.3>@.4
/*──────────────────────────────────SET_ISIN subroutine─────────────────*/
set_isin:    parse arg #,x;     call set_val x
if \datatype(#,'N')        then call set_bad "number isn't not numeric:" #
                if (@.1=='(' &  #<=@.2) |,
                   (@.1=='[' &  #< @.2) |,
                   (@.4==')' &  #>=@.3) |,
                   (@.4==']' &  #> @.3)    then return 0
return 1
/*──────────────────────────────────SET_query subroutine────────────────*/
set_query:  parse arg lv,hv,s1 oop s2 .;  op=oop;   upper op;      cop=
if lv==''  then lv=0;      if hv==''  then hv=2;    if op=='' then cop=0
if wordpos(op,'| or UNION')                 \==0              then cop='|'
if wordpos(op,'& ∩ AND INTER INTERSECTION') \==0              then cop='&'
if wordpos(op,'\ - DIF DIFF DIFFERENCE')    \==0              then cop='\'
if cop==''  then call set_bad 'invalid operation:' oop
say
        do i=lv  to hv;  b =set_isin(i,s1)
        if cop\==0  then do
                         b2=set_isin(i,s2)
                         if cop=='&' then b=b & b2
                         if cop=='|' then b=b | b2
                         if cop=='\' then b=b & \b2
                         end
        express = s1 center(oop,max(5,length(oop))) s2
        say right(i,5) ' is in set'  express": "   word('no yes',b+1)
        end   /*i*/
return
/*──────────────────────────────────SET_VAL subroutine──────────────────*/
set_val:     parse arg q;           q=space(q,0);   L=length(q);   @.0=','
infinity = copies(9,digits()-1)'e'copies(9,digits()-1)'0'
if L<2                              then call set_bad 'invalid expression'
@.4=right(q,1)
parse var q @.1 2 @.2 ',' @.3 (@.4)
if @.1\=='(' & @.1\=='['  then call set_bad 'left boundry'
if @.4\==')' & @.4\==']'  then call set_bad 'right boundry'

         do j=2  to 3;   u=@.j;   upper u
         if right(@.j,1)=='∞' | u="INFINITY"  then @.j='-'infinity
         if \datatype(@.j,'N')   then call set_bad 'value not numeric:' @.j
         end  /*j*/

if @.2>@.3 then parse var L . @.0 @.2 @.3
return space(@.1 @.2 @.0 @.3 @.4,0)
