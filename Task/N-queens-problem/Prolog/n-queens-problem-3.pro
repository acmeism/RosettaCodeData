solution(Ylist) :-
 sol(Ylist,[1,2,3,4,5,6,7,8],
    [1,2,3,4,5,6,7,8],
    [-7,-6,-5,-4,-3,-2,-1,0,1,2,3,4,5,6,7],
    [2,3,4,5,6,7,8,9,10,11,12,13,14,15,16]).

sol([],[],[],Du,Dv).

sol([Y|Ylist],[X|Dx1],Dy,Du,Dv) :-
 del(Y,Dy,Dy1),
 U is X-Y,
 del(U,Du,Du1),
 V is X+Y,
 del(V,Dv,Dv1),
 sol(Ylist,Dx1, Dy1,Du1,Dv1).

del(Item,[Item|List],List).

del(Item,[First|List],[First|List1]) :-
 del(Item,List,List1).
