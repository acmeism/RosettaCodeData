:- initialization(main).

solve(N,Xs,Ast) :-
    Err = evaluation_error(zero_divisor)
  , gen_ast(Xs,Ast), catch(Ast =:= N, error(Err,_), fail)
  .

gen_ast([N],N) :- between(1,9,N).
gen_ast(Xs,Ast) :-
    Ys = [_|_], Zs = [_|_], split(Xs,Ys,Zs)
  , ( member(Op, [(+),(*)]), Ys @=< Zs ; member(Op, [(-),(//)]) )
  , gen_ast(Ys,A), gen_ast(Zs,B), Ast =.. [Op,A,B]
  .

split(Xs,Ys,Zs) :- sublist(Ys,Xs), select_all(Ys,Xs,Zs).
    % where
    select_all([],Xs,Xs).
    select_all([Y|Ys],Xs,Zs) :- select(Y,Xs,X1), !, select_all(Ys,X1,Zs).


test(T) :- solve(24, [2,3,8,9], T).
main :- forall(test(T), (write(T), nl)), halt.
