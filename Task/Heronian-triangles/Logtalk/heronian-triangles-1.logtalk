% In this example we assume that A<=B<=C.
% Non-pedagogical code would verify and force this.
:- object(triangle(_A_, _B_, _C_)).

    :- public([a/1, b/1, c/1, area/1, perimeter/1, primitive/0]).

    a(_A_). b(_B_). c(_C_).

    area(A) :-
        AB is _A_ + _B_,
        AB @> _C_,        % you can't make a triangle if one side is half or longer the perimeter
        s(S),
        A is sqrt(S * (S - _A_) * (S - _B_) * (S - _C_)).

    perimeter(P) :-
        P is _A_ + _B_ + _C_.

    primitive :- heronian, gcd(1).

    % helper predicates

    heronian :-
        integer(_A_),
        integer(_B_),
        integer(_C_),
        area(A),
        A > 0.0,
        0.0 is float_fractional_part(A).

    gcd(G) :- G is gcd(_A_, gcd(_B_, _C_)).

    s(S) :- perimeter(P), S is P / 2.

:- end_object.
