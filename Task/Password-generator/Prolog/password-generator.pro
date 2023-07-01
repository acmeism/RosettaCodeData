:- set_prolog_flag(double_quotes, chars).
:- initialization(main, main).

main( Argv ) :-
    opt_spec( Spec ),
    opt_parse( Spec, Argv, Opts, _ ),
    (
        member( help(true), Opts ) -> show_help
        ;
        member( length( Len ), Opts ),
        member( number( Num ), Opts ),
        print_set_of_passwords( Len, Num )
    ).

show_help :-
    opt_spec( Spec ),
    opt_help( Spec, HelpText ),
    write( 'Usage: swipl pgen.pl <options>\n\n' ),
    write( HelpText ),
    nl.

opt_spec([
    [opt(help),   type(boolean), default(false), shortflags([h]), longflags([help]),
        help('Show Help')],
    [opt(length), type(integer), default(10),    shortflags([l]), longflags([length]),
        help('Specify the length of each password.')],
    [opt(number), type(integer), default(1),     shortflags([n]), longflags([number]),
        help('Specify the number of passwords to create.')]
]).

print_set_of_passwords( Length, Number ) :-
    forall(
         between( 1, Number, _ ),
        (
            random_pword( Length, P ),
            maplist( format('~w'), P ),
            nl
        )
    ).

random_pword( Length, Pword ) :-
    length( GenPword, Length ),
    findall( C, pword_char( _, C), PwordChars ),
    repeat,
    maplist(populate_pword( PwordChars ), GenPword ),
    maplist( pword_char_rule( GenPword ), [lower, upper, digits, special] ),
    random_permutation( GenPword, Pword ).

populate_pword( PwordChars, C ) :- random_member( C, PwordChars ).

pword_char_rule( Pword, Type ) :-
    pword_char( Type, C ),
    member( C, Pword).

pword_char( lower, C ) :- member( C, "abcdefghijklmnopqrstuvwxyz" ).
pword_char( upper, C ) :- member( C, "ABCDEFGHIJKLMNOPQRSTUVWXYZ" ).
pword_char( digits, C ) :- member( C, "0123456789" ).
pword_char( special, C ) :- member( C, "!\"#$%&'()*+,-./:;<=>?@[]^_{|}~" ).
