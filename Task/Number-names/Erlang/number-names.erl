-module(nr2eng).
-import(lists, [foreach/2, seq/2, append/2]).
-import(string, [strip/3, str/2]).
-export([start/0]).

sym(1) -> "one";
sym(2) -> "two";
sym(3) -> "three";
sym(4) -> "four";
sym(5) -> "five";
sym(6) -> "six";
sym(7) -> "seven";
sym(8) -> "eight";
sym(9) -> "nine";
sym(10) -> "ten";
sym(11) -> "eleven";
sym(12) -> "twelve";
sym(13) -> "thirteen";
sym(20) -> "twenty";
sym(30) -> "thirty";
sym(40) -> "forty";
sym(50) -> "fifty";
sym(100) -> "hundred";
sym(1000) -> "thousand";
sym(1000*1000) -> "million";
sym(1000*1000*1000) -> "billion";
sym(_) -> "".

next(1000) -> 100;
next(100) -> 10;
next(10) -> 1;
next(X) -> X div 1000.

concat(PRE, "") ->
   PRE;
concat(PRE, POST) ->
   PRE++" "++POST.
concat("", _, POST) ->
   POST;
concat(PRE, SYM, "") ->
   PRE++" "++SYM;
concat(PRE, SYM, POST) ->
   PRE++" "++SYM++" "++POST.

nr2eng(0, _) ->
   "";
nr2eng(NR, 1) ->
   sym(NR);
nr2eng(NR, 10) when NR =< 20 ->
   case sym(NR) of
        "" -> strip(sym(NR-10), right, $t) ++ "teen";
        _  -> sym(NR)
   end;
nr2eng(NR, 10) ->
   concat(
     case sym((NR div 10)*10) of
        "" -> strip(sym(NR div 10), right, $t) ++ "ty";
        _  -> sym((NR div 10)*10)
     end,
     nr2eng(NR rem 10, 1));
nr2eng(NR, B) ->
   PRE  = nr2eng(NR div B, next(B)),
   POST = nr2eng(NR rem B, next(B)),
   AND  = str(POST, "and"),
   COMMA = if
              POST == "" -> "";
              AND == 0 -> " and";
              B >= 1000 -> ",";
              true -> ""
   end,
   concat(PRE,  sym(B)++COMMA, POST).

start() ->
   lists:foreach(
     fun (X) -> io:fwrite("~p ~p ~n", [X, nr2eng(X, 1000000000)])
     end,
     append(seq(1, 2000), [123123, 43234234])).
