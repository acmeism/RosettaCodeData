main:-
    writeln('Decimal\tBinary'),
    main(1, 1000).

main(N, Limit):-
    format(string(Binary), '~2r', N),
    string_length(Binary, Length),
    I is N + (N << Length),
    I < Limit,
    !,
    writef('%w\t%w%w\n', [I, Binary, Binary]),
    N1 is N + 1,
    main(N1, Limit).
main(_, _).
