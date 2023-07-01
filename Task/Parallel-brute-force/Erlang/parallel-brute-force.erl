#! /usr/bin/escript
-mode(compile).
-export([cracker/4, supervisor/3]).

hexdigit(N) when (N >= 0) and (N =< 9) -> N + $0;
hexdigit(N) when (N >= 10) and (N < 16) -> N - 10 + $a.

hexbyte(N) -> [hexdigit(N bsr 4), hexdigit(N band 15)].

match(Key, Hash) ->
    B = crypto:hash(sha256, Key),
    Hash == lists:append([hexbyte(X) || <<X:8/integer>> <= B]).

cracker(Prefixes, Rest, Hashes, Boss) ->
    Results = [[[P|Q], Hash]
        || P <- Prefixes, Q <- Rest, Hash <- Hashes, match([P|Q], Hash)],
    Boss ! {done, Results}.

supervisor(0, Results, Caller) -> Caller ! {done, Results};
supervisor(Tasks, Results, Caller) ->
    receive
        {done, Cracked} -> supervisor(Tasks - 1, Cracked ++ Results, Caller)
    end.

main(_) ->
    Tasks = ["abc", "def", "ghi", "jkl", "mno", "pqr", "stuv", "wxyz"],
    Letter = lists:seq($a, $z),
    Rest = [[B, C, D, E] || B <- Letter, C <- Letter, D <- Letter, E <- Letter],
    Hashes = [
        "1115dd800feaacefdf481f1f9070374a2a81e27880f187396db67958b207cbad",
        "3a7bd3e2360a3d29eea436fcfb7e44c735d117c42d1c1835420b6b9942dd4f1b",
        "74e1bb62f8dabb8125a58852b63bdf6eaef667cb56ac7f7cdba6d7305c50a22f"
    ],
    Boss = spawn(?MODULE, supervisor, [length(Tasks), [], self()]),
    [spawn(?MODULE, cracker, [Prefixes, Rest, Hashes, Boss])
        || Prefixes <- Tasks],

    receive
        {done, Results} -> Results
    end,

    [io:format("~s: ~s~n", Result) || Result <- Results].
