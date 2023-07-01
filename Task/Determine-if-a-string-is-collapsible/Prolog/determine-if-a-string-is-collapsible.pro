collapse_( [], [] ).
collapse_( [A], [A] ).
collapse_( [A,A|T], R ) :- collapse_( [A|T], R ).
collapse_( [A,B|T], [A|R] ) :- dif( A, B ), collapse_( [B|T], R ).

collapse( Str, Collapsed ) :-
    string_chars( Str, Chars ),
    collapse_( Chars, Result ),
    string_chars( Collapsed, Result ).
