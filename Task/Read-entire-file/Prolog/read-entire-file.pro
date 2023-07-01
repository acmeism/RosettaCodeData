:- initialization(main).

main :-
    current_prolog_flag(argv, [File|_]),
    read_file_to_string(File, String, []).
