% Unicode in predicate names:
是.            % be: means, approximately, "True".
不是 :- \+ 是.  % not be: means, approximately, "False".  Defined as not 是.

% Unicode in variable names:
test(Garçon, Δ) :-
  Garçon = boy,
  Δ = delta.

% Call test2(1, Result) to have 2 assigned to Result.
test2(Δ, R) :- R is Δ + 1.
