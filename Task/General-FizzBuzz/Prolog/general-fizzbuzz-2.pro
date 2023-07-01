go :- maxNumber(M), factors(Fs), MLast is M+1, loop(1,MLast,Fs).

loop(B,B,_).
loop(A,B,Fs) :-
    A < B, fizzbuzz(A,Fs,S), ( (S = "", Res is A) ; Res = S ), writeln(Res),
    Next is A+1, loop(Next,B,Fs).

fizzbuzz(_,[],"").
fizzbuzz(N,[(F,S)|Fs],Res) :-
    fizzbuzz(N,Fs,OldRes),
    ( N mod F =:= 0, string_concat(S,OldRes,Res) ; Res = OldRes ).
