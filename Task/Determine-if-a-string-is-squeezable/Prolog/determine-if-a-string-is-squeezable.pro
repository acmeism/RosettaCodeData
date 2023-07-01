squeeze_( [], _, [] ).
squeeze_( [A], _, [A] ).
squeeze_( [A,A|T], A, R ) :- squeeze_( [A|T], A, R ).
squeeze_( [A,A|T], B, [A|R] ) :- dif( A, B ), squeeze_( [A|T], B, R ).
squeeze_( [A,B|T], S, [A|R] ) :- dif( A, B ), squeeze_( [B|T], S, R ).

squeeze( Str, SqueezeChar, Collapsed ) :-
    string_chars( Str, Chars ),
    squeeze_( Chars, SqueezeChar, Result ),
    string_chars( Collapsed, Result ).
