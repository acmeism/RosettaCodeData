:- system:set_prolog_flag(double_quotes,chars) .

%! strip_chars(SOURCEz0,SETz0,TARGETz)
%
% `TARGETz` is `SOURCEz0` but with any of the characters in `SETz0` removed .

strip_chars(SOURCEz0,SETz0,TARGETz)
:-
prolog:phrase(strip_chars(SOURCEz0,SETz0),TARGETz)
.

strip_chars([],_SETz0_) --> ! .

strip_chars([SOURCE0|SOURCEz0],SETz0)
-->
{ \+ \+ lists:member(SOURCE0,SETz0) } ,
! ,
strip_chars(SOURCEz0,SETz0)
.

strip_chars([SOURCE0|SOURCEz0],SETz0)
-->
[SOURCE0] ,
strip_chars(SOURCEz0,SETz0)
.
