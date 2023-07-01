:- initialization(main).


zebra(X) :-
    houses(Hs), member(h(_,X,zebra,_,_), Hs)
  , findall(_, (member(H,Hs), write(H), nl), _), nl
  , write('the one who keeps zebra: '), write(X), nl
  .


houses(Hs) :-
    Hs = [_,_,_,_,_]                         %  1
  , H3 = h(_,_,_,milk,_), Hs = [_,_,H3,_,_]  %  9
  , H1 = h(_,nvg,_,_,_ ), Hs = [H1|_]        % 10

  , maplist( flip(member,Hs),
       [ h(red,eng,_,_,_)                    %  2
       , h(_,swe,dog,_,_)                    %  3
       , h(_,dan,_,tea,_)                    %  4
       , h(green,_,_,coffe,_)                %  6
       , h(_,_,birds,_,pm)                   %  7
       , h(yellow,_,_,_,dh)                  %  8
       , h(_,_,_,beer,bm)                    % 13
       , h(_,ger,_,_,pri)                    % 14
       ])

  , infix([ h(green,_,_,_,_)
          , h(white,_,_,_,_) ], Hs)          %  5

  , maplist( flip(nextto,Hs),
      [ [h(_,_,_,_,bl   ), h(_,_,cats,_,_)]  % 11
      , [h(_,_,horse,_,_), h(_,_,_,_,dh  )]  % 12
      , [h(_,nvg,_,_,_  ), h(blue,_,_,_,_)]  % 15
      , [h(_,_,_,water,_), h(_,_,_,_,bl  )]  % 16
      ])
  .


flip(F,X,Y) :- call(F,Y,X).

infix(Xs,Ys) :- append(Xs,_,Zs) , append(_,Zs,Ys).
nextto(P,Xs) :- permutation(P,R), infix(R,Xs).


main :- findall(_, (zebra(_), nl), _), halt.
