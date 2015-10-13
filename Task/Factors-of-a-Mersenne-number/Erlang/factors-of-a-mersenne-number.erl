-module(mersene2).
-export([prime/1,modpow/3,mf/1]).

mf(P) -> merseneFactor(P,math:sqrt(math:pow(2,P)-1),2).

merseneFactor(P,Limit,Acc) when Acc >= Limit -> io:write("None found");
merseneFactor(P,Limit,Acc) ->
        Q = 2 * P * Acc + 1,
        Isprime = prime(Q),
        Mod = modpow(2,P,Q),

        if
            Isprime == false ->
               merseneFactor(P,Limit,Acc+1);

            Q rem 8 =/= 1 andalso Q rem 8 =/= 7 ->
               merseneFactor(P,Limit,Acc+1);

             Mod == 1 ->
                io:format("M~w is composite with Factor: ~w~n",[P,Q]);

            true -> merseneFactor(P,Limit,Acc+1)
        end.

modpow(B, E, M) -> modpow(B, E, M, 1).

modpow(_B, E, _M, R) when E =< 0 -> R;
modpow(B, E, M, R) ->
    R1 = case E band 1 =:= 1 of
             true -> (R * B) rem M;
             false  -> R
         end,
    modpow( (B*B) rem M, E bsr 1, M, R1).

prime(N) -> divisors(N, N-1).

divisors(N, 1) -> true;
divisors(N, C) ->
   case N rem C =:= 0 of
      true  -> false;
      false -> divisors(N, C-1)
   end.
