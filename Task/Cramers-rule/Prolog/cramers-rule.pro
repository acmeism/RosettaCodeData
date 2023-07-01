removeElement([_|Tail], 0, Tail).
removeElement([Head|Tail], J, [Head|X]) :-
    J_2 is J - 1,
    removeElement(Tail, J_2, X).

removeColumn([], _, []).
removeColumn([Matrix_head|Matrix_tail], J, [X|Y]) :-
    removeElement(Matrix_head, J, X),
    removeColumn(Matrix_tail, J, Y).

removeRow([_|Matrix_tail], 0, Matrix_tail).
removeRow([Matrix_head|Matrix_tail], I, [Matrix_head|X]) :-
    I_2 is I - 1,
    removeRow(Matrix_tail, I_2, X).

cofactor(Matrix, I, J, X) :-
    removeRow(Matrix, I, Matrix_2),
    removeColumn(Matrix_2, J, Matrix_3),
    det(Matrix_3, Y),
    X is (-1) ** (I + J) * Y.

det_summand(_, _, [], 0).
det_summand(Matrix, J, B, X) :-
    B = [B_head|B_tail],
    cofactor(Matrix, 0, J, Z),
    J_2 is J + 1,
    det_summand(Matrix, J_2, B_tail, Y),
    X is B_head * Z + Y.

det([[X]], X).
det(Matrix, X) :-
    Matrix = [Matrix_head|_],
    det_summand(Matrix, 0, Matrix_head, X).

replaceElement([_|Tail], 0, New, [New|Tail]).
replaceElement([Head|Tail], J, New, [Head|Y]) :-
    J_2 is J - 1,
    replaceElement(Tail, J_2, New, Y).

replaceColumn([], _, _, []).
replaceColumn([Matrix_head|Matrix_tail], J, [Column_head|Column_tail], [X|Y]) :-
    replaceElement(Matrix_head, J, Column_head, X),
    replaceColumn(Matrix_tail, J, Column_tail, Y).

cramerElements(_, B, L, []) :- length(B, L).
cramerElements(A, B, J, [X_J|Others]) :-
    replaceColumn(A, J, B, A_J),
    det(A_J, Det_A_J),
    det(A, Det_A),
    X_J is Det_A_J / Det_A,
    J_2 is J + 1,
    cramerElements(A, B, J_2, Others).

cramer(A, B, X) :- cramerElements(A, B, 0, X).

results(X) :-
    A = [
            [2, -1,  5,  1],
            [3,  2,  2, -6],
            [1,  3,  3, -1],
            [5, -2, -3,  3]
        ],
    B = [-3, -32, -47, 49],
    cramer(A, B, X).
