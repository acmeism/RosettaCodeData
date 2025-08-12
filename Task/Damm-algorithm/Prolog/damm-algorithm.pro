%!  damm_algorithm(+Number) is semidet.
%   Succeeds if the number is valid according to the Damm algorithm.
damm_algorithm(Number) :-
    Matrix = [
        [0, 3, 1, 7, 5, 9, 8, 6, 4, 2],
        [7, 0, 9, 2, 1, 5, 4, 8, 6, 3],
        [4, 2, 0, 6, 8, 7, 1, 3, 5, 9],
        [1, 7, 5, 0, 9, 8, 3, 4, 2, 6],
        [6, 1, 2, 3, 0, 4, 5, 9, 7, 8],
        [3, 6, 7, 4, 2, 0, 9, 5, 8, 1],
        [5, 8, 6, 9, 7, 2, 0, 1, 3, 4],
        [8, 9, 4, 5, 3, 6, 2, 0, 1, 7],
        [9, 4, 3, 8, 6, 1, 7, 2, 0, 5],
        [2, 5, 8, 1, 4, 3, 6, 7, 9, 0]
    ],
    number_codes(Number, Codes),
    foldl(damm_algorithm(Matrix), Codes, 0, 0).

damm_algorithm(Matrix, Code, N0, N) :-
    Digit is Code - 48,
    nth0(N0, Matrix, Row),
    nth0(Digit, Row, N).

:- foreach(member(Number, [5724, 5727, 112946, 112949]), (
    ( damm_algorithm(Number) -> write(Number is valid) ; write(Number is invalid) ),
    nl
)).
