:- initialization(main, main).
:- use_module(library(dcg/basics), [blanks/2, eol/2, integer/3]).
:- use_module(library(dcg/high_order), [sequence/4, sequence/5]).

%!  numbers_to_stem_leaves(+Numbers, -StemLeaves) is det.
%   Converts a list of Numbers to a list of Stem-Leaves pairs.
numbers_to_stem_leaves(Numbers, StemLeaves) :-
    findall(Stem - Leaves, (
        group_by(Stem, Leaf, (
            member(Number, Numbers),
            divmod(Number, 10, Stem, Leaf)
        ), Leaves0),
        msort(Leaves0, Leaves)
    ), StemLeaves).

stem_leaf_plot(StemLeaves) --> sequence(stem_leaves, StemLeaves).

stem_leaves(Stem - Leaves) --> rpad_integer(4, Stem), " | ", sequence(integer, " ", Leaves), "\n".

rpad_integer(Pad, N) -->
    (   { Pad0 is Pad - 1, N < 10 ^ Pad0, \+ ( Pad = 1, N = 0 ) }
    ->  " ", rpad_integer(Pad0, N)
    ;   integer(N)
    ).

%!  display_stem_leaf_plot(Numbers) is det.
%   Prints the stem-and-leaf plot of a list of Numbers.
display_stem_leaf_plot(Numbers) :-
    numbers_to_stem_leaves(Numbers, StemLeaves),
    once(phrase(stem_leaf_plot(StemLeaves), Codes)),
    format("~s", [Codes]).

int(N) --> integer(N), blanks.

main([Filename]) :-
    phrase_from_file((blanks, sequence(int, Numbers)), Filename),
    display_stem_leaf_plot(Numbers).
