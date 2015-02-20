select([A|As],S):- select(A,S,S1),select(As,S1).
select([],_).

next_to(A,B,C):- left_of(A,B,C) ; left_of(B,A,C).
left_of(A,B,C):- append(_,[A,B|_],C).

zebra(Owns, HS):-  % color,nation,pet,drink,smokes
      HS =    [ h(_,norwegian,_,_,_), _,  h(_,_,_,milk,_), _, _],
      select( [ h(red,englishman,_,_,_),  h(_,swede,dog,_,_),
                h(_,dane,_,tea,_),        h(_,german,_,_,prince) ], HS),
      select( [ h(_,_,birds,_,pallmall),  h(yellow,_,_,_,dunhill),
                h(_,_,_,beer,bluemaster) ],                         HS),
      left_of(  h(green,_,_,coffee,_),    h(white,_,_,_,_),         HS),
      next_to(  h(_,_,_,_,dunhill),       h(_,_,horse,_,_),         HS),
      next_to(  h(_,_,_,_,blend),         h(_,_,cats, _,_),         HS),
      next_to(  h(_,_,_,_,blend),         h(_,_,_,water,_),         HS),
      next_to(  h(_,norwegian,_,_,_),     h(blue,_,_,_,_),          HS),
      member(   h(_,Owns,zebra,_,_), HS).

:- ?- time(( zebra(Who, HS), maplist(writeln,HS), nl, write(Who), nl, nl, fail
             ; write('No more solutions.') )).
