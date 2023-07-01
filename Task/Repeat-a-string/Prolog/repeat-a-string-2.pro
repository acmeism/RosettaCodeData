:- system:set_prolog_flag(double_quotes,chars) .

repeat(SOURCEz0,COUNT0,TARGETz)
:-
prolog:phrase(repeat(SOURCEz0,COUNT0),TARGETz)
.

%! repeat(SOURCEz0,COUNT0)//2

repeat(_SOURCEz0_,0)
-->
! ,
[]
.

repeat(SOURCEz0,COUNT0)
-->
SOURCEz0 ,
{ COUNT is COUNT0 - 1 } ,
repeat(SOURCEz0,COUNT)
.
