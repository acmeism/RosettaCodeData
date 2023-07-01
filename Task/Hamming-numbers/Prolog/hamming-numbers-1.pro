%% collect N elements produced by a generator in a row

take( 0, Next, Z-Z, Next).
take( N, Next, [A|B]-Z, NZ):- N>0, !, next(Next,A,Next1),
  N1 is N-1,
  take(N1,Next1,B-Z,NZ).

%% a generator provides specific {next} implementation

next( hamm( A2,B,C3,D,E5,F,[H|G] ), H, hamm(X,U,Y,V,Z,W,G) ):-
  H is min(A2, min(C3,E5)),
  (   A2 =:= H -> B=[N2|U],X is N2*2 ; (X,U)=(A2,B) ),
  (   C3 =:= H -> D=[N3|V],Y is N3*3 ; (Y,V)=(C3,D) ),
  (   E5 =:= H -> F=[N5|W],Z is N5*5 ; (Z,W)=(E5,F) ).

mkHamm( hamm(1,X,1,X,1,X,X) ).       % Hamming numbers generator init state

main(N) :-
    mkHamm(G),take(20,G,A-[],_),           write(A), nl,
    take(1691-1,G,_,G2),take(2,G2,B-[],_),     write(B), nl,
    take(  N  -1,G,_,G3),take(2,G3,[C1|_]-_,_),   write(C1), nl.
