execute( Term ) :-
  Term =.. [F | Args],
  forall( member(X,Args), (G =.. [F,X], G, nl) ).
