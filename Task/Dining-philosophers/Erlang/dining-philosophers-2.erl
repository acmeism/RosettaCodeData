%%% This version uses free-running 'phil' agents (actors) and
%%% state machines representing the forks.
%%%
%%% Usage to compile and run:
%%% $ erl
%%%   > c(dining).
%%%   {ok,dining}
%%%   > dining:start().
%%%

-module( dining).
-export(
    [ start/0
    ]).
-vsn( 1).
-date( '6/2020').
-author( bksteele).
-email( 'drbenkman@gmail.com').

%% fork messages: grab | drop | quit
%% a quit message is accepted only when State = available
%% @param Id numeric identification of object
%% @param State: available | in_use

fork( Id, available ) ->
    receive
    { From, Who, grab} ->
        From ! { self(), Who, Id}
        , fork( Id, in_use)
    ;
    { From, quit} ->
        From ! { quit}
        , ok
    end
    ;
fork( Id, in_use ) ->
    receive
    { From, Who, drop} ->
        From ! { self(), Who, Id}
        , fork( Id, available)
    end
    .

%% sleep/1 : Integer -> ok
%% sleep pauses a process for T milliseconds.
%% @param T milliseconds for the time period

sleep(T) ->
    receive
        after T -> true
    end
    .

%% grab/2 : Pid String -> ()
%% Fork is the shared resource (a process object).
%% Who is the name of the acting process.
%% grab encapsulates message transmission.
%% @param Fork pid to which to send messages
%% @param Who name of the sender

grab( Fork, Who) ->
    Fork ! { self(), Who, grab}
    , receive
    { Fork, Who, _Id} -> ok
    end
    .

%% drop/2 : Pid String -> ()
%% Fork is the shared resource (a process object).
%% Who is the name of the acting process.
%% drop encapsulates message transmission.
%%
%% @param Fork pid to which to send messages
%% @param Who name of the sender

drop( Fork, Who) ->
    Fork ! { self(), Who, drop}
    , receive
    { Fork, Who, _Id} -> ok
    end
    .


%% phil/3 : String List{Id,Pid} Integer -> ok
%% phil/3 philosopher process uses a fork process.
%% phil uses two fork objects for n eating cycles.
%% A phil needs the pids of resource to communicate,
%% and the names of the fork resources it uses.
%% @param Name the string name of the philosopher
%% @param List{Id, Pid} 2 pairs of Id and Fork
%% @param Cycle the number of cycles to run

phil( Name, [{LId, Left}, {RId, Right}], Cycle)
    when LId > RId ->
        % swap so that process picks numerically lower first.
        % the swap introduces asymmetry to prevent deadlock.
        phil( Name, {RId, Right}, {LId, Left}, Cycle)
    ;
phil( Name, [{LId, Left}, {RId, Right}], Cycle) ->
    phil( Name, {LId, Left}, {RId, Right}, Cycle).


%% phil/4 : String {LId,LeftF} {RId,RightF} Integer -> ok
%% phil/4 philosopher process uses a fork process.
%% phil uses two fork objects for n eating cycles.
%% A phil needs pids of resource to communicate
%% and the names of the fork resources it uses.
%% @param Name the string name of the philosopher
%% @param {LeftId, Fork} pair of Id and Fork pid
%% @param {RightId, Fork} pair of Id and Fork pid
%% @param Cycle the number of cycles to run

phil( Name, _LFork, _RFork, 0) ->
    io:format( "~s is done.~n", [Name])
    ;
phil( Name, {LId, Left}, {RId, Right}, Cycle) ->

    io:format( "~s is thinking.~n", [Name])
    , sleep( rand:uniform( 1000))
    , io:format( "~s is hungry.~n", [Name])

    , grab( Left, Name)
    , grab( Right, Name)

    , io:format( "~s is eating.~n", [Name])
    , sleep( rand:uniform( 1000))

    , drop( Left, Name)
    , drop( Right, Name)

    , phil( Name, [{LId, Left}, {RId, Right}]
        , Cycle - 1)
    .

%% make_forks/1 : N -> List{Id, Fork}

make_forks( N) when N > 0 -> make_forks( N, []).

%% make_forks/2 : N List{Id, Fork}

make_forks( 0, Forks ) -> lists:reverse( Forks)
    ;
make_forks( N, Forks) ->
    % create and run the fork processes
    Pair = { N, spawn(
        fun() -> fork( N, available) end) }
    , make_forks( N-1
            , lists:append( Forks, [Pair] ))
    .

%% make_phils/2 : Names, ForkList -> List{String}

make_phils( Names, Forks)
    when length( Names) > 0 ->
        make_phils( Names, Forks, [])
    .

%% make_phils/3 : Names Forks PL -> List{Fun}
%% make_phil/3 hard-codes the eat cycle count to 7

make_phils( [], _Forks, PhilList) -> PhilList
    ;
make_phils( [Hn|Tn], [Lf, Rf |FList], PhilList) ->
    % create a phil process function but do not run yet
    Phil = fun() -> phil( Hn, [Lf, Rf], 7) end
    , make_phils( Tn, rot( [Lf, Rf |FList], 1)
                , lists:append( PhilList, [Phil]))
    .

%% rot/2 : List Num -> List
%% rotate or roll a list by N slots, and return new list

rot( List, 0 ) -> List
    ;
rot( [H], 1 ) -> [H]
    ;
rot( [H|List], N ) ->
    rot( lists:append( List, [H]), N - 1)
    .

%% start free-running philosopher agents competing for Forks
%% start is fixed with N = 5 philosophers and 5 forks.

start() ->
    % create Fork list
    N = 5
    , Forks = make_forks( N)

    , Names = [ "Aristotle", "Kant"
              , "Spinoza", "Marx", "Russell"]

    , Phils = make_phils( Names, Forks)

    % run the philosophers now
    , [spawn( P) || P <- Phils]
    , ok
    .
