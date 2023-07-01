-module(lcs).

%% API exports
-export([
        lcs/2
]).

%%====================================================================
%% API functions
%%====================================================================

lcs(A, B) ->
        {LCS, _Cache} = get_lcs(A, B, [], #{}),
        lists:reverse(LCS).

%%====================================================================
%% Internal functions
%%=====================================================

get_lcs(A, B, Acc, Cache) ->
        case maps:find({A, B, Acc}, Cache) of
                {ok, LCS} -> {LCS, Cache};
                error     ->
                        {NewLCS, NewCache} = compute_lcs(A, B, Acc, Cache),
                        {NewLCS, NewCache#{ {A, B, Acc} => NewLCS }}
        end.

compute_lcs(A, B, Acc, Cache) when length(A) == 0 orelse length(B) == 0 ->
        {Acc, Cache};
compute_lcs([Token |ATail], [Token |BTail], Acc, Cache) ->
        get_lcs(ATail, BTail, [Token |Acc], Cache);
compute_lcs([_AToken |ATail]=A, [_BToken |BTail]=B, Acc, Cache) ->
        {LCSA, CacheA} = get_lcs(A, BTail, Acc, Cache),
        {LCSB, CacheB} = get_lcs(ATail, B, Acc, CacheA),
        LCS = case length(LCSA) > length(LCSB) of
                true  -> LCSA;
                false -> LCSB
        end,
        {LCS, CacheB}.
