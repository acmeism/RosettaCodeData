-module(tests).
-export([md5/1]).

md5(S) ->
 string:to_upper(
  lists:flatten([io_lib:format("~2.16.0b",[N]) || <<N>> <= erlang:md5(S)])
 ).
