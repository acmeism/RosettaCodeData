-module(singleton).

-export([get/0, set/1, start/0]).

-export([loop/1]).

% spec singleton:get() -> {ok, Value::any()} | not_set
get() ->
     ?MODULE ! {get, self()},
     receive
	{ok, not_set} -> not_set;
        Answer -> Answer
     end.

% spec singleton:set(Value::any()) -> ok
set(Value) ->
    ?MODULE ! {set, self(), Value},
    receive
        ok -> ok
    end.

start() ->
    register(?MODULE, spawn(?MODULE, loop, [not_set])).

loop(Value) ->
    receive
        {get, From} ->
             From ! {ok, Value},
             loop(Value);
        {set, From, NewValue} ->
             From ! ok,
             loop(NewValue)
        end.
