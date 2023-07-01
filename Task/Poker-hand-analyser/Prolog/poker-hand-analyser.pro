:- initialization(main).


faces([a,k,q,j,10,9,8,7,6,5,4,3,2]).

face(F) :- faces(Fs), member(F,Fs).
suit(S) :- member(S, ['♥','♦','♣','♠']).


best_hand(Cards,H) :-
    straight_flush(Cards,C) -> H = straight-flush(C)
  ; many_kind(Cards,F,4)    -> H = four-of-a-kind(F)
  ; full_house(Cards,F1,F2) -> H = full-house(F1,F2)
  ; flush(Cards,S)          -> H = flush(S)
  ; straight(Cards,F)       -> H = straight(F)
  ; many_kind(Cards,F,3)    -> H = three-of-a-kind(F)
  ; two_pair(Cards,F1,F2)   -> H = two-pair(F1,F2)
  ; many_kind(Cards,F,2)    -> H = one-pair(F)
  ; many_kind(Cards,F,1)    -> H = high-card(F)
  ;                            H = invalid
  .

straight_flush(Cards, c(F,S)) :- straight(Cards,F), flush(Cards,S).

full_house(Cards,F1,F2) :-
    many_kind(Cards,F1,3), many_kind(Cards,F2,2), F1 \= F2.

flush(Cards,S) :- maplist(has_suit(S), Cards).
has_suit(S, c(_,S)).

straight(Cards,F) :-
    select(c(F,_), Cards, Cs), pred_face(F,F1), straight(Cs,F1).
straight([],_).
pred_face(F,F1) :- F = 2 -> F1 = a ; faces(Fs), append(_, [F,F1|_], Fs).

two_pair(Cards,F1,F2) :-
    many_kind(Cards,F1,2), many_kind(Cards,F2,2), F1 \= F2.

many_kind(Cards,F,N) :-
    face(F), findall(_, member(c(F,_), Cards), Xs), length(Xs,N).


% utils/parser
parse_line(Cards)  --> " ", parse_line(Cards).
parse_line([C|Cs]) --> parse_card(C), parse_line(Cs).
parse_line([])     --> [].

parse_card(c(F,S)) --> parse_face(F), parse_suit(S).

parse_suit(S,In,Out) :- suit(S), atom_codes(S,Xs), append(Xs,Out,In).
parse_face(F,In,Out) :- face(F), face_codes(F,Xs), append(Xs,Out,In).

face_codes(F,Xs) :- number(F) -> number_codes(F,Xs) ; atom_codes(F,Xs).


% tests
test(" 2♥  2♦ 2♣ k♣  q♦").
test(" 2♥  5♥ 7♦ 8♣  9♠").
test(" a♥  2♦ 3♣ 4♣  5♦").
test(" 2♥  3♥ 2♦ 3♣  3♦").
test(" 2♥  7♥ 2♦ 3♣  3♦").
test(" 2♥  7♥ 7♦ 7♣  7♠").
test("10♥  j♥ q♥ k♥  a♥").
test(" 4♥  4♠ k♠ 5♦ 10♠").
test(" q♣ 10♣ 7♣ 6♣  4♣").

run_tests :-
    test(Line), phrase(parse_line(Cards), Line), best_hand(Cards,H)
  , write(Cards), write('\t'), write(H), nl
  .
main :- findall(_, run_tests, _), halt.
