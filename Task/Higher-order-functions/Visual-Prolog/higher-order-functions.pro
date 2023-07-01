domains
  intFunction = (integer In) -> integer Out procedure (i).

class predicates
  addone : intFunction.
  doTwice : (intFunction, integer) -> integer procedure (i, i).

clauses
  doTwice(Pred,X) = Y :- Y = Pred(Pred(X)).

  addone(X) = Y := Y = X + 1.

  run():-
    init(),
    write(dotwice(addone,2)),
    succeed().
