printAll( List ) :- forall( member(X,List), (write(X), nl)).
