:- system:set_prolog_flag(double_quotes,chars) .

occurrences(TARGETz0,SUBSTRINGz0,COUNT)
:-
prolog:phrase(occurrences(SUBSTRINGz0,0,COUNT),TARGETz0)
.

occurrences("",_,_)
-->
! ,
{ false }
.

occurrences(SUBSTRINGz0,COUNT0,COUNT)
-->
SUBSTRINGz0 ,
! ,
{ COUNT1 is COUNT0 + 1 } ,
occurrences(SUBSTRINGz0,COUNT1,COUNT)
.

occurrences(SUBSTRINGz0,COUNT0,COUNT)
-->
[_] ,
! ,
occurrences(SUBSTRINGz0,COUNT0,COUNT)
.

occurrences(_SUBSTRINGz0_,COUNT,COUNT)
-->
!
.
