check(Row) :-
    nth1(King, Row, ♔),
    nth1(Rook1, Row, ♖),
    nth1(Rook2, Row, ♖),
    nth1(Bishop1, Row, ♗),
    nth1(Bishop2, Row, ♗),
    Rook1 < King, King < Rook2,
    (Bishop1 + Bishop2) mod 2 =:= 1.

generate(Row) :-
    random_permutation([♖,♘,♗,♕,♔,♗,♘,♖], Row),
    check(Row) ; generate(Row).
