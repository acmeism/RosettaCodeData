:- initialization(main).

command_table("Add ALTer  BAckup Bottom  CAppend Change SCHANGE  CInsert CLAst COMPress COpy
COUnt COVerlay CURsor DELete CDelete Down DUPlicate Xedit EXPand EXTract Find
NFind NFINDUp NFUp CFind FINdup FUp FOrward GET Help HEXType Input POWerinput
Join SPlit SPLTJOIN  LOAD  Locate CLocate  LOWercase UPPercase  LPrefix MACRO
MErge MODify MOve MSG Next Overlay PARSE PREServe PURge PUT PUTD  Query  QUIT
READ  RECover REFRESH RENum REPeat  Replace CReplace  RESet  RESTore  RGTLEFT
RIght LEft  SAVE  SET SHift SI  SORT  SOS  STAck STATus  TOP TRAnsfer Type Up").

validate("", _, "") :- !.

validate(Word, Commands, Result) :-
    member(Command, Commands),
    string_concat(Prefix, Suffix, Command),
    string_upper(Prefix, Prefix),
    string_lower(Suffix, Suffix),
    string_lower(Word, LowWord),
    string_lower(Prefix, LowPrefix),
    string_concat(LowPrefix, _, LowWord),
    string_lower(Command, LowCommand),
    string_concat(LowWord, _, LowCommand),
    string_upper(Command, Result),
    !.

validate(_, _, "*error*").

main :-
    current_prolog_flag(argv, Args),
    command_table(Table),
    split_string(Table, " \t\n", "", Commands),
    forall(member(Arg, Args), (
        atom_string(Arg, Word),
        validate(Word, Commands, Result),
        format("~w ", Result)
    )),
    nl.
