:- initialization(main).


bubble_sort(Xs,Res) :-
    write(Xs), nl
  , bubble_pass(Xs,Ys,Changed)
  , ( Changed == true -> bubble_sort(Ys,Res) ; Res = Xs )
  .

bubble_pass(Xs,Res,Changed) :-
    Xs = [X|Ys], Ys = [Y|Zs]
  , ( X > Y -> H = Y, T = [X|Zs], Changed = true
             ; H = X, T = Ys
    )
  , Res = [H|R], !, bubble_pass(T,R,Changed)
  ; Res = Xs
  .


test([8,9,1,3,4,2,6,5,4]).

main :- test(T), bubble_sort(T,_), halt.
