hopido(Grid,[C|Solved],Xs,Ys) :-	
	select(C,Grid,RGrid),
	solve(RGrid,C,Solved,Xs,Ys).
	
solve([],_,[],_,_).	
solve(Grid,p(X,Y),[p(X1,Y1)|R],Xs,Ys) :-
	valid_move(X,Y,Xs,Ys,X1,Y1),
	select(p(X1,Y1),Grid,NextGrid),
	solve(NextGrid,p(X1,Y1),R,Xs,Ys).	
	
valid_move(X,Y,Xs,_,X1,Y)   :- j3(X,X1,Xs).			% right	(3,0)
valid_move(X,Y,Xs,_,X1,Y)   :- j3(X1,X,Xs).			% left (-3,0)
valid_move(X,Y,_,Ys,X,Y1)   :- j3(Y,Y1,Ys).			% up (0,3).
valid_move(X,Y,_,Ys,X,Y1)   :- j3(Y1,Y,Ys).  			% down (0,-3).
valid_move(X,Y,Xs,Ys,X1,Y1) :- j2(X,X1,Xs), j2(Y,Y1,Ys).  	% up-right (2,2).
valid_move(X,Y,Xs,Ys,X1,Y1) :- j2(X1,X,Xs), j2(Y,Y1,Ys).  	% up-left (-2,2).
valid_move(X,Y,Xs,Ys,X1,Y1) :- j2(X1,X,Xs), j2(Y1,Y,Ys).  	% down-left (-2,-2).
valid_move(X,Y,Xs,Ys,X1,Y1) :- j2(X,X1,Xs), j2(Y1,Y,Ys).  	% down-right (2,-2).

j2(O,N,[O,_,N|_]).
j2(O,N,[_|T]) :- j2(O,N,T).

j3(O,N,[O,_,_,N|_]).
j3(O,N,[_|T]) :- j3(O,N,T).
