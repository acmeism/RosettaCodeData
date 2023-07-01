% Point
point_construct(X, Y, point(X1,Y1)) :-
	default(X, X1),
	default(Y, Y1).

% Circle
circle_construct(X, Y, R, circle(X1,Y1,R1)) :-
	default(X, X1),
	default(Y, Y1),
	default(R, R1).
	
% Accessors for general X,Y
% individual getters/setters can be made but it is not required
shape_x_y_set(point(_,_), X, Y, point(X,Y)).
shape_x_y_set(circle(_,_,R), X, Y, circle(X,Y,R)).

% Accessors for R
cicle_r_set(circle(X,Y,_), R, circle(X,Y,R)).

% Print
print_shape(point(X,Y)) :- format('Point (~p,~p)', [X,Y]).
print_shape(circle(X,Y,R)) :- format('Circle (~p,~p,~p)', [X,Y,R]).

% Default values for constructor (default to 0).
default(N, 0) :- var(N).
default(N, N) :- number(N).

% Tests
test_point :-
	point_construct(2,3,P),
	test_poly(P).
	
test_circle :-
	circle_construct(3,4,_,C),
	cicle_r_set(C, 5, C1),
	test_poly(C1).

test_poly(T) :-
	shape_x_y_set(_, X, Y, T),
	X1 is X * 2,
	Y1 is Y * 2,
	shape_x_y_set(T, X1, Y1, T1),	
	print_shape(T1).
