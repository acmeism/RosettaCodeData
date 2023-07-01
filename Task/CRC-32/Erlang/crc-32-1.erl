-module(crc32).
-export([test/0]).
test() ->
  io:fwrite("~.16#~n",[erlang:crc32(<<"The quick brown fox jumps over the lazy dog">>)]).
