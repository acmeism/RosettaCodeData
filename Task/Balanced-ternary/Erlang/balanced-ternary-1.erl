-module(ternary).
-compile(export_all).

test() ->
    AS = "+-0++0+", AT = from_string(AS), A = from_ternary(AT),
    B = -436, BT = to_ternary(B), BS = to_string(BT),
    CS = "+-++-", CT = from_string(CS), C = from_ternary(CT),
    RT = mul(AT,sub(BT,CT)),
    R = from_ternary(RT),
    RS = to_string(RT),
    io:fwrite("A = ~s -> ~b~n",[AS, A]),
    io:fwrite("B = ~s -> ~b~n",[BS, B]),
    io:fwrite("C = ~s -> ~b~n",[CS, C]),
    io:fwrite("A x (B - C) = ~s -> ~b~n", [RS, R]).

to_string(T) -> [to_char(X) || X <- T].

from_string(S) -> [from_char(X) || X <- S].

to_char(-1) -> $-;
to_char(0) -> $0;
to_char(1) -> $+.

from_char($-) -> -1;
from_char($0) -> 0;
from_char($+) -> 1.

to_ternary(N) when N > 0 ->
    to_ternary(N,[]);
to_ternary(N) ->
    neg(to_ternary(-N)).

to_ternary(0,Acc) ->
    Acc;
to_ternary(N,Acc) when N rem 3 == 0 ->
    to_ternary(N div 3, [0|Acc]);
to_ternary(N,Acc) when N rem 3 == 1 ->
    to_ternary(N div 3, [1|Acc]);
to_ternary(N,Acc) ->
    to_ternary((N+1) div 3, [-1|Acc]).

from_ternary(T) -> from_ternary(T,0).

from_ternary([],Acc) ->
    Acc;
from_ternary([H|T],Acc) ->
    from_ternary(T,Acc*3 + H).

mul(A,B) -> mul(B,A,[]).

mul(_,[],Acc) ->
    Acc;
mul(B,[A|As],Acc) ->
    BP = case A of
             -1 -> neg(B);
             0 ->  [0];
             1 ->  B
         end,
    A1 = Acc++[0],
    A2=add(BP,A1),
    mul(B,As,A2).


neg(T) -> [ -H || H <- T].

sub(A,B) -> add(A,neg(B)).

add(A,B) when length(A) < length(B) ->
    add(lists:duplicate(length(B)-length(A),0)++A,B);
add(A,B) when length(A) > length(B) ->
   add(B,A);
add(A,B) ->
    add(lists:reverse(A),lists:reverse(B),0,[]).

add([],[],0,Acc) ->
    Acc;
add([],[],C,Acc) ->
    [C|Acc];
add([A|As],[B|Bs],C,Acc) ->
    [C1,D] = add_util(A+B+C),
    add(As,Bs,C1,[D|Acc]).

add_util(-3) -> [-1,0];
add_util(-2) -> [-1,1];
add_util(-1) -> [0,-1];
add_util(3) -> [1,0];
add_util(2) -> [1,-1];
add_util(1) -> [0,1];
add_util(0) -> [0,0].
