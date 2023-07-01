% submitted by Aykayayciti (Earl Lamont Montgomery)
% altered from fsaenzperez April 2019
% (swi-prolog.discourse-group)
test_run :-
        proc_dir('C:\\vvvv\\vvvv_beta_39_x64').


proc_dir(Directory) :-
    format('Directory: ~w~n',[Directory]),
    directory_files(Directory,Files),!,  %cut inserted
    proc_files(Directory,Files).

proc_files(Directory, [File|Files]) :-
    proc_file(Directory, File),!, %cut inserted
    proc_files(Directory, Files).
proc_files(_Directory, []).

proc_file(Directory, File) :-
    (
        File = '.',
        directory_file_path(Directory, File, Path),
        exists_directory(Path),!,%cut inserted
        format('Directory: ~w~n',[File])
    ;
        File = '..',
        directory_file_path(Directory, File, Path),
        exists_directory(Path),!,%cut inserted
        format('Directory: ~w~n',[File])
    ;
        directory_file_path(Directory, File, Path),
        exists_directory(Path),!,%cut inserted
        proc_dir(Path)
    ;
        directory_file_path(Directory, File, Path),
        exists_file(Path),!,%cut inserted
        format('File: ~w~n',[File])
    ;
        format('Unknown: ~w~n',[File])
    ).
