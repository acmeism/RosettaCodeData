chars :-
    findall(Lower, maplist(char_type(Lower), [alpha, ascii, lower]), Lowers),

    writeln('-- Lower Case Characters --'),
    writeln(Lowers),
    nl,

    findall(Upper, maplist(char_type(Upper), [alpha, ascii, upper]), Uppers),
    writeln('-- Upper Case Characters --'),
    writeln(Uppers).
