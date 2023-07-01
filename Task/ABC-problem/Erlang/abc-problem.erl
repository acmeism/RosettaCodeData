-module(abc).
-export([can_make_word/1, can_make_word/2, blocks/0]).

blocks() -> ["BO", "XK", "DQ", "CP", "NA", "GT", "RE", "TG", "QD", "FS",
             "JW", "HU", "VI", "AN", "OB", "ER", "FS", "LY", "PC", "ZM"].

can_make_word(Word) -> can_make_word(Word, blocks()).
can_make_word(Word, Avail) -> can_make_word(string:to_upper(Word), Avail, []).
can_make_word([], _, _) -> true;
can_make_word(_, [], _) -> false;
can_make_word([L|Tail], [B|Rest], Tried) ->
  (lists:member(L,B) andalso can_make_word(Tail, lists:append(Rest, Tried),[]))
  orelse can_make_word([L|Tail], Rest, [B|Tried]).

main(_) -> lists:map(fun(W) -> io:fwrite("~s: ~s~n", [W, can_make_word(W)]) end,
                     ["A","Bark","Book","Treat","Common","Squad","Confuse"]).
