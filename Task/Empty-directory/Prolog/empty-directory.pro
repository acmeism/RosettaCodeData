non_empty_file('.').
non_empty_file('..').

empty_dir(Dir) :-
	directory_files(Dir, Files),
	maplist(non_empty_file, Files).
