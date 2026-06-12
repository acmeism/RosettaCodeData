:- system:set_prolog_flag(double_quotes,chars) .

:- [library(lists)] .

%! remove_vowels(INPUTz0,OUTPUTz0)
%
% `OUTPUTz0` is `INPUTz0` but without any vowels .

remove_vowels(INPUTz0,OUTPUTz0)
:-
prolog:phrase(remove_vowels(INPUTz0),OUTPUTz0)
.

remove_vowels([])
-->
[]
.

remove_vowels([INPUT0|INPUTz0])
-->
{ vowel(INPUT0) } ,
! ,
remove_vowels(INPUTz0)
.

remove_vowels([INPUT0|INPUTz0])
-->
! ,
[INPUT0] ,
remove_vowels(INPUTz0)
.

vowel(CHAR)
:-
lists:member(CHAR,"AEIOUaeiouüéâäàåçêëèïîìÄÅÉæÆôöòûùÿÖÜáíóúªºαΩ")
.
