-module(lcp).
-export([ main/0 ]).

data() -> [
  ["interspecies", "interstellar", "interstate"],
  ["throne", "throne"],
  ["throne", "dungeon"],
  ["throne", "", "throne"],
  ["cheese"],
  [""],
  [],
  ["prefix", "suffix"],
  ["foo", "foobar"]
].

main() -> [io:format("~p -> \"~s\"~n",[Strs,lcp(Strs)]) || Strs <- data()].

lcp(      []) -> [];
lcp([S|Strs]) -> lists:foldl( fun(X,Y) -> lcp(X,Y,[]) end, S, Strs).

lcp([X|Xs], [X|Ys], Pre) -> lcp(Xs, Ys, [X|Pre]);
lcp(     _,      _, Pre) -> lists:reverse(Pre).
