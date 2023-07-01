:- system:set_prolog_flag(double_quotes,codes) .

strip_block_comments(INPUTz)
:-
strip_block_comments(INPUTz,OUTPUTz) ,
system:format("```~n",[OUTPUTz]) ,
system:format("~s~n",[OUTPUTz]) ,
system:format("```~n",[OUTPUTz])
.

strip_block_comments(INPUTz,OUTPUTz)
:-
prolog:phrase(block(OUTPUTz),INPUTz)
.

block([]) --> \+ [_] , ! .
block([CODE|OUTPUTz]) --> \+ comment , ! , [CODE] , block(OUTPUTz) .
block(OUTPUTz) --> comment , ! , block(OUTPUTz) .

comment --> comment_entr , zero_or_more(comment_each) , comment_exit .
comment_entr --> "/*" .
comment_each --> comment , ! .
comment_each --> \+ comment_exit , ! , [_] .
comment_exit --> "*/" .

zero_or_more(CALLABLE) --> call(CALLABLE) , ! , zero_or_more(CALLABLE) .
zero_or_more(_) --> ! .
