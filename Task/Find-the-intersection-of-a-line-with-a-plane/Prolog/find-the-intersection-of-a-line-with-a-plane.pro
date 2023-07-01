:- initialization(main).

vector_plus(U, V, W) :-
    U = p(X1, Y1, Z1),
    V = p(X2, Y2, Z2),
    X3 is X1 + X2,
    Y3 is Y1 + Y2,
    Z3 is Z1 + Z2,
    W = p(X3, Y3, Z3).

vector_minus(U, V, W) :-
    U = p(X1, Y1, Z1),
    V = p(X2, Y2, Z2),
    X3 is X1 - X2,
    Y3 is Y1 - Y2,
    Z3 is Z1 - Z2,
    W = p(X3, Y3, Z3).

vector_times(U, S, V) :-
    U = p(X1, Y1, Z1),
    X2 is X1 * S,
    Y2 is Y1 * S,
    Z2 is Z1 * S,
    V = p(X2, Y2, Z2).

vector_dot(U, V, S) :-
    U = p(X1, Y1, Z1),
    V = p(X2, Y2, Z2),
    S is X1 * X2 + Y1 * Y2 + Z1 * Z2.

intersect_point(RayVector, RayPoint, PlaneNormal, PlanePoint, IntersectPoint) :-
    vector_minus(RayPoint, PlanePoint, Diff),
    vector_dot(Diff, PlaneNormal, Prod1),
    vector_dot(RayVector, PlaneNormal, Prod2),
    Prod3 is Prod1 / Prod2,
    vector_times(RayVector, Prod3, Times),
    vector_minus(RayPoint, Times, IntersectPoint).

main :-
    RayVector = p(0.0, -1.0, -1.0),
    RayPoint = p(0.0, 0.0, 10.0),
    PlaneNormal = p(0.0, 0.0, 1.0),
    PlanePoint = p(0.0, 0.0, 5.0),
    intersect_point(RayVector, RayPoint, PlaneNormal, PlanePoint, p(X, Y, Z)),
    format("The ray intersects the plane at (~f, ~f, ~f)\n", [X, Y, Z]).
