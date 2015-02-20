:- initialization(main).


solve(Rows) :-
    maplist(domain_1_9, Rows)
  , different(Rows)
  , transpose(Rows,Cols), different(Cols)
  , blocks(Rows,Blocks) , different(Blocks)
  , maplist(fd_labeling, Rows)
  .

domain_1_9(Rows) :- fd_domain(Rows,1,9).
different(Rows)  :- maplist(fd_all_different, Rows).

blocks(Rows,Blocks) :-
    maplist(split3,Rows,Xs), transpose(Xs,Ys)
  , concat(Ys,Zs), concat_map(split3,Zs,Blocks)
  . % where
    split3([X,Y,Z|L],[[X,Y,Z]|R]) :- split3(L,R).
    split3([],[]).


% utils/list
concat_map(F,Xs,Ys) :- call(F,Xs,Zs), maplist(concat,Zs,Ys).

concat([],[]).
concat([X|Xs],Ys) :- append(X,Zs,Ys), concat(Xs,Zs).

transpose([],[]).
transpose([[X]|Col], [[X|Row]]) :- transpose(Col,[Row]).
transpose([[X|Row]], [[X]|Col]) :- transpose([Row],Col).
transpose([[X|Row]|Xs], [[X|Col]|Ys]) :-
    maplist(bind_head, Row, Ys, YX)
  , maplist(bind_head, Col, Xs, XY)
  , transpose(XY,YX)
  . % where
    bind_head(H,[H|T],T).
    bind_head([],[],[]).


% tests
test([ [_,_,3,_,_,_,_,_,_]
     , [4,_,_,_,8,_,_,3,6]
     , [_,_,8,_,_,_,1,_,_]
     , [_,4,_,_,6,_,_,7,3]
     , [_,_,_,9,_,_,_,_,_]
     , [_,_,_,_,_,2,_,_,5]
     , [_,_,4,_,7,_,_,6,8]
     , [6,_,_,_,_,_,_,_,_]
     , [7,_,_,6,_,_,5,_,_]
     ]).

main :- test(T), solve(T), maplist(show,T), halt.
show(X) :- write(X), nl.
