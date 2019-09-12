-module(pi).
-export([agmPi/1, agmPiBody/5]).

agmPi(Loops) ->
    % Tail recursive function that produces pi from the Arithmetic Geometric Mean method
    A = 1,
    B = 1/math:sqrt(2),
    J = 1,
    Running_divisor = 0.25,
    A_n_plus_one = 0.5*(A+B),
    B_n_plus_one = math:sqrt(A*B),
    Step_difference = A_n_plus_one - A,
    agmPiBody(Loops-1, Running_divisor-(math:pow(Step_difference, 2)*J), A_n_plus_one, B_n_plus_one, J+J).

agmPiBody(0, Running_divisor, A, _, _) ->
    math:pow(A, 2)/Running_divisor;
agmPiBody(Loops, Running_divisor, A, B, J) ->
    A_n_plus_one = 0.5*(A+B),
    B_n_plus_one = math:sqrt(A*B),
    Step_difference = A_n_plus_one - A,
    agmPiBody(Loops-1, Running_divisor-(math:pow(Step_difference, 2)*J), A_n_plus_one, B_n_plus_one, J+J).
