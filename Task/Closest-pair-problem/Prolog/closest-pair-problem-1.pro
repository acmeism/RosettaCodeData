% main predicate, find and print closest point
do_find_closest_points(Points) :-
	points_closest(Points, points(point(X1,Y1),point(X2,Y2),Dist)),
	format('Point 1 : (~p, ~p)~n', [X1,Y1]),
	format('Point 1 : (~p, ~p)~n', [X2,Y2]),
	format('Distance: ~p~n', [Dist]).

% Find the distance between two points
distance(point(X1,Y1), point(X2,Y2), points(point(X1,Y1),point(X2,Y2),Dist)) :-
	Dx is X2 - X1,
	Dy is Y2 - Y1,
	Dist is sqrt(Dx * Dx + Dy * Dy).

% find the closest point that relatest to another point
point_closest(Points, Point, Closest) :-
	select(Point, Points, Remaining),
	maplist(distance(Point), Remaining, PointList),
	foldl(closest, PointList, 0, Closest).

% find the closest point/dist pair for all points
points_closest(Points, Closest) :-
	maplist(point_closest(Points), Points, ClosestPerPoint),
	foldl(closest, ClosestPerPoint, 0, Closest).

% used by foldl to get the lowest point/distance combination
closest(points(P1,P2,Dist), 0, points(P1,P2,Dist)).
closest(points(_,_,Dist), points(P1,P2,Dist2), points(P1,P2,Dist2)) :-
	Dist2 < Dist.
closest(points(P1,P2,Dist), points(_,_,Dist2), points(P1,P2,Dist)) :-
	Dist =< Dist2.
