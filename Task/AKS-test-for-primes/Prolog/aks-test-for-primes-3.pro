%%% Task 1: "A method to generate the coefficients of (1-X)^p"

coefficients(N, Coefficients) :-
  pascal(N, X),
  alternate_signs(X, Coefficients).

alternate_signs( [], [] ).
alternate_signs( [A], [A] ).
alternate_signs( [A,B | X], [A, MB | Y] ) :-
  MB is -B,
  alternate_signs(X,Y).

%%% Task 2. "Show here the polynomial expansions of (x − 1)p for p in the range 0 to at least 7, inclusive."

coefficients(Coefficients) :-
  optpascal( Opt),
  pascalize( Opt, Row ),
  alternate_signs(Row, Coefficients).


%  As required by the problem statement, but necessarily very inefficient:
:- between(0, 7, N), coefficients(N, Coefficients), writeln(Coefficients), fail ; true.
