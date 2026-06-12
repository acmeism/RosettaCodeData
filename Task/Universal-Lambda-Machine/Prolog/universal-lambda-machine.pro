:- set_prolog_flag(double_quotes, chars).

/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    List.
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

skip(N, Es0, Es) :-
    '@skip'(0, N, Es0, Es).

'@skip'(N0, N, Es0, Es) :-
    N0 == N, !,
    Es0 = Es.
'@skip'(N, N, Es, Es).
'@skip'(N0, N, [_|Es1], Es) :-
    N1 is N0+1,
    '@skip'(N1, N, Es1, Es).

foldl(_G_3, [], S, S).
foldl(G_3, [E|Es], S0, S) :-
    call(G_3, E, S0, S1),
    foldl(G_3, Es, S1, S).

/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    BLC.
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

% De Bruijn index.
blc_expr(v(N)) --> blc_variable(N).
blc_expr(l(E)) --> blc_lambda(E).
blc_expr(a(E0,E1)) --> blc_application(E0, E1).

blc_variable(N) --> "1", '@blc_count'(0, N).
blc_lambda(E) --> "00", blc_expr(E).
blc_application(E0, E1) --> "01", blc_expr(E0), blc_expr(E1).

'@blc_count'(N0, N) --> { N0 == N }, !, "0".
'@blc_count'(N, N) --> "0".
'@blc_count'(N0, N) --> "1", { N1 is N0+1 }, '@blc_count'(N1, N).


% Local variable of the argument.
'@blc_shift'(_, >, v(N), v(N)).
% Global variable of the argument.
'@blc_shift'(M, =, v(N0), v(N)) :-
    N is M+N0.
% Global variable of the argument.
'@blc_shift'(M, <, v(N0), v(N)) :-
    N is M+N0.

blc_shift(M, L, v(N0), v(N)) :-
    compare(O, L, N0),
    '@blc_shift'(M, O, v(N0), v(N)).
blc_shift(M, L0, l(E0), l(E)) :-
    L is L0+1,
    blc_shift(M, L, E0, E).
blc_shift(M, L, a(E0,A0), a(E,A)) :-
    blc_shift(M, L, E0, E),
    blc_shift(M, L, A0, A).

blc_substitute(Z, L, v(N), E) :-
    compare(O, L, N),
    '@blc_substitute'(O, Z, v(N), E).
blc_substitute(Z, L0, l(E0), l(E)) :-
    L is L0+1,
    blc_substitute(Z, L, E0, E).
blc_substitute(Z, L, a(E0,A0), a(E,A)) :-
    blc_substitute(Z, L, E0, E),
    blc_substitute(Z, L, A0, A).

% Local variable.
'@blc_substitute'(>, _, v(N), v(N)).
% Variable to substitute.
'@blc_substitute'(=, E0, v(N), E) :-
    blc_shift(N, 0, E0, E).
% Global variable.
'@blc_substitute'(<, _, v(N0), v(N)) :-
    N is N0-1, N @>= 0.

% https://web.archive.org/web/20241118083658/https://www.itu.dk/%7Esestoft/papers/sestoft-lamreduce.pdf#page=5

'@blc_cbn'(A0, v(N), a(v(N),A0)).
'@blc_cbn'(A0, l(E0), E) :-
    blc_substitute(A0, 0, E0, E1),
    blc_cbn(E1, E).
'@blc_cbn'(A0, a(E1,A1), a(a(E1,A1),A0)).

blc_cbn(v(N), v(N)).
blc_cbn(l(E), l(E)).
blc_cbn(a(E0,A0), E) :-
    blc_cbn(E0, E1),
    '@blc_cbn'(A0, E1, E).

'@blc_nor'(A0, v(N), a(v(N),A)) :-
    blc_nor(A0, A).
'@blc_nor'(A0, l(E0), E) :-
    blc_substitute(A0, 0, E0, E1),
    blc_nor(E1, E).
'@blc_nor'(A0, a(E1,A1), a(E,A)) :-
    blc_nor(a(E1,A1), E),
    blc_nor(A0, A).

blc_nor(v(N), v(N)).
blc_nor(l(E0), l(E1)) :-
    blc_nor(E0, E1).
blc_nor(a(E0,A0), E) :-
    blc_cbn(E0, E1),
    '@blc_nor'(A0, E1, E).

/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    Krivine.
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

'@ksubstitute_variable'(>, _, _, v(I), v(I)).
'@ksubstitute_variable'(=, Env, L, v(I0), E) :-
    I is I0-L,
    skip(I, Env, [E0-Env0|_]),
    ksubstitute(Env0, 0, E0, E).
'@ksubstitute_variable'(<, Env, L, v(I0), E) :-
    I is I0-L,
    skip(I, Env, [E0-Env0|_]),
    ksubstitute(Env0, 0, E0, E).

ksubstitute(Env, L, v(I0), E) :-
    compare(O, L, I0),
    '@ksubstitute_variable'(O, Env, L, v(I0), E).
ksubstitute(Env, L0, l(E0), l(E)) :-
    L is L0+1,
    ksubstitute(Env, L, E0, E).
ksubstitute(Env, L, a(E0,A0), a(E,A)) :-
    ksubstitute(Env, L, E0, E),
    ksubstitute(Env, L, A0, A).

% Source: https://arxiv.org/abs/1802.00640v5
krivine(M0, M) :-
    '@krivine'([M0-[]], [M1-Env]),
    ksubstitute(Env, 0, M1, M).

'@krivine'(S0, S) :-
    '@kstep'(S0, S1), !,
    '@krivine'(S1, S).
'@krivine'(S, S).

'@kstep'([v(I)-Env0|Env], [C|Env]) :-
    skip(I, Env0, [C|_]).
'@kstep'([l(M)-Env0,N-Env1|Env], [M-[N-Env1|Env0]|Env]).
'@kstep'([a(M,N)-Env0|Env], [M-Env0,N-Env0|Env]).

/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    Interpreter.
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

get_chars(Cs0) :-
    get_char(C),
    C \== end_of_file, !,
    [C|Cs] = Cs0,
    get_chars(Cs).
get_chars([]).

encode('0', l(a(a(v(0),l(l(v(1)))),E)), E).
encode('1', l(a(a(v(0),l(l(v(0)))),E)), E).

decode(l(l(v(1))), '0').
decode(l(l(v(0))), '1').

machine(E0) :-
    krivine(a(E0,l(l(v(1)))), E1),
    blc_nor(E1, E2),
    krivine(a(E0,l(l(v(0)))), E3),
    once(decode(E2, C)),
    put_char(C), flush_output,
    machine(E3).

interpret :-
    Nil = l(l(v(0))),
    get_chars(Cs0),
    phrase(blc_expr(E0), Cs0, Cs1),
    once(foldl(encode, Cs1, A0, Nil)),
    machine(a(E0,A0)),
    false.
interpret :-
    halt.
