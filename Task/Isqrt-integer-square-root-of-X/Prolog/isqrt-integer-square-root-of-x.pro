%%% -*- Prolog -*-
%%%
%%% The Rosetta Code integer square root task, for SWI Prolog.
%%%

%% pow4gtx/2 -- Find a power of 4 greater than X.
pow4gtx(X, Q) :- pow4gtx(X, 1, Q), !.
pow4gtx(X, A, Q) :- X < A, Q is A.
pow4gtx(X, A, Q) :- A1 is A * 4,
                    pow4gtx(X, A1, Q).

%% isqrt/2 -- Find integer square root.
%% isqrt/3 -- Find integer square root and remainder.
isqrt(X, R) :- isqrt(X, R, _).
isqrt(X, R, Z) :- pow4gtx(X, Q),
                  isqrt(X, Q, 0, X, R, Z).
isqrt(_, 1, R0, Z0, R, Z) :- R is R0,
                             Z is Z0.
isqrt(X, Q, R0, Z0, R, Z) :- Q1 is Q // 4,
                             T is Z0 - R0 - Q1,
                             (T >= 0
                             -> R1 is (R0 // 2) + Q1,
                                isqrt(X, Q1, R1, T, R, Z)
                             ;  R1 is R0 // 2,
                                isqrt(X, Q1, R1, Z0, R, Z)).

roots(N) :- roots(0, N).
roots(I, N) :- isqrt(I, R),
               write(R),
               (I =:= N; write(" ")),
               I1 is I + 1,
               (N < I1, !; roots(I1, N)).

rootspow7(N) :- rootspow7(1, N).
rootspow7(I, N) :- Pow7 is 7**I,
                   isqrt(Pow7, R),
                   format("~t~D~2|~t~D~87|~t~D~131|~n",
                          [I, Pow7, R]),
                   I1 is I + 2,
                   (N < I1, !; rootspow7(I1, N)).

main :-
  format("isqrt(i) for 0 <= i <= 65:~2n"),
  roots(65),
  format("~3n"),
  format("isqrt(7**i) for 1 <= i <= 73, i odd:~2n"),
  format("~t~s~2|~t~s~87|~t~s~131|~n",
         ["i", "7**i", "isqrt(7**i)"]),
  format("-----------------------------------------------------------------------------------------------------------------------------------~n"),
  rootspow7(73),
  halt.

:- initialization(main).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Instructions for GNU Emacs--
%%% local variables:
%%% mode: prolog
%%% prolog-indent-width: 2
%%% end:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
