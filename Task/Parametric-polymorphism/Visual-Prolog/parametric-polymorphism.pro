domains
   tree{Type} = branch(tree{Type} Left, tree{Type} Right); leaf(Type Value).

class predicates
   treewalk : (tree{X},function{X,Y}) -> tree{Y} procedure (i,i).

clauses
   treewalk(branch(Left,Right),Func) = branch(NewLeft,NewRight) :-
        NewLeft = treewalk(Left,Func), NewRight = treewalk(Right,Func).

   treewalk(leaf(Value),Func) = leaf(X) :-
        X = Func(Value).

   run():-
       init(),
       X = branch(leaf(2), branch(leaf(3),leaf(4))),
       Y = treewalk(X,addone),
       write(Y),
       succeed().
