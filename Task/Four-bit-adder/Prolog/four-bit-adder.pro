% binary 4 bit adder chip simulation

b_not(in(hi), out(lo)) :- !.      % not(1) = 0
b_not(in(lo), out(hi)).           % not(0) = 1

b_and(in(hi,hi), out(hi)) :- !.   % and(1,1) = 1
b_and(in(_,_), out(lo)).          % and(anything else) = 0

b_or(in(hi,_), out(hi)) :- !.     % or(1,any) = 1
b_or(in(_,hi), out(hi)) :- !.     % or(any,1) = 1
b_or(in(_,_), out(lo)).           % or(anything else) = 0

b_xor(in(A,B), out(O)) :-
    b_not(in(A), out(NotA)), b_not(in(B), out(NotB)),
    b_and(in(A,NotB), out(P)), b_and(in(NotA,B), out(Q)),
    b_or(in(P,Q), out(O)).

b_half_adder(in(A,B), s(S), c(C)) :-
    b_xor(in(A,B),out(S)), b_and(in(A,B),out(C)).

b_full_adder(in(A,B,Ci), s(S), c(C1)) :-
  b_half_adder(in(Ci, A), s(S0), c(C0)),
  b_half_adder(in(S0, B), s(S), c(C)),
  b_or(in(C0,C), out(C1)).

b_4_bit_adder(in(A0,A1,A2,A3), in(B0,B1,B2,B3), out(S0,S1,S2,S3), c(V)) :-
  b_full_adder(in(A0,B0,lo), s(S0), c(C0)),
  b_full_adder(in(A1,B1,C0), s(S1), c(C1)),
  b_full_adder(in(A2,B2,C1), s(S2), c(C2)),
  b_full_adder(in(A3,B3,C2), s(S3), c(V)).

test_add(A,B,T) :-
  b_4_bit_adder(A, B, R, C),
  writef('%w + %w is %w %w  \t(%w)\n', [A,B,R,C,T]).

go :-
  test_add(in(hi,lo,lo,lo), in(hi,lo,lo,lo), '1 + 1 = 2'),
  test_add(in(lo,hi,lo,lo), in(lo,hi,lo,lo), '2 + 2 = 4'),
  test_add(in(hi,lo,hi,lo), in(hi,lo,lo,hi), '5 + 9 = 14'),
  test_add(in(hi,hi,lo,hi), in(hi,lo,lo,hi), '11 + 9 = 20'),
  test_add(in(lo,lo,lo,hi), in(lo,lo,lo,hi), '8 + 8 = 16'),
  test_add(in(hi,hi,hi,hi), in(hi,lo,lo,lo), '15 + 1 = 16').
