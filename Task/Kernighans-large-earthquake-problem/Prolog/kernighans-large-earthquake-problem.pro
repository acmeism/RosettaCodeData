:- initialization(main, main).

process_line(Line):-
    split_string(Line, "\s\t", "\s\t", [_, _, Magnitude_string]),
    read_term_from_atom(Magnitude_string, Magnitude, []),
    Magnitude > 6,
    !,
    writef('%w\n', [Line]).
process_line(_).

process_stream(Stream):-
    read_line_to_string(Stream, String),
    String \= end_of_file,
    !,
    process_line(String),
    process_stream(Stream).
process_stream(_).

process_file(File):-
    open(File, read, Stream),
    process_stream(Stream),
    close(Stream).

main([File]):-
    process_file(File),
    !.
main(_):-
    swritef(Message, 'File argument is missing\n', []),
    write(user_error, Message).
