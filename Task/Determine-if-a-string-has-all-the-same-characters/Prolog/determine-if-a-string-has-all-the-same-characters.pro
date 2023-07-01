:- system:set_prolog_flag(double_quotes,chars) .

main
:-
same_or_different("") ,
same_or_different("   ") ,
same_or_different("2") ,
same_or_different("333") ,
same_or_different(".55") ,
same_or_different("tttTTT") ,
same_or_different("4444 444k")
.

%!  same_or_different(INPUTz0)

same_or_different(INPUTz0)
:-
system:format('input string is "~s" .~n',[INPUTz0]) ,
examine(INPUTz0)
.

%!  examine(INPUTz0)

examine([])
:-
! ,
system:format('all the same characters .~n',[])
.

examine([COMPARE0|INPUTz0])
:-
examine(INPUTz0,COMPARE0,2,_INDEX_)
.

%!  examine(INPUTz0,COMPARE0,INDEX0,INDEX)

examine([],_COMPARE0_,INDEX0,INDEX0)
:-
! ,
system:format('all the same characters .~n',[])
.

examine([COMPARE0|INPUTz0],COMPARE0,INDEX0,INDEX)
:-
! ,
INDEX1 is INDEX0 + 1 ,
examine(INPUTz0,COMPARE0,INDEX1,INDEX)
.

examine([DIFFERENT0|_INPUTz0_],COMPARE0,INDEX0,INDEX0)
:-
prolog:char_code(DIFFERENT0,DIFFERENT_CODE) ,
system:format('character "~s" (hex ~16r) different than "~s" at 1-based index ~10r .~n',[[DIFFERENT0],DIFFERENT_CODE,[COMPARE0],INDEX0])
.
