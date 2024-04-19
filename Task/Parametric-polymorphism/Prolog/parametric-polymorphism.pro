% Tree Definition
tree(leaf(_)).
tree(branch(Left, Right)) :- tree(Left), tree(Right).

% Definition of the addone function
addone(X, Y) :- Y is X + 1.

% Definition of treewalk
treewalk(leaf(Value), Func, leaf(NewValue)) :- call(Func, Value, NewValue).
treewalk(branch(Left, Right), Func, branch(NewLeft, NewRight)) :-
     treewalk(Left, Func, NewLeft),
     treewalk(Right, Func, NewRight).

% Execution
run :-
     X = branch(leaf(2), branch(leaf(3),leaf(4))),
     treewalk(X, addone, Y),
     write(Y).
