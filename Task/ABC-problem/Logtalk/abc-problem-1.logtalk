:- object(blocks(_Block_Set_)).

    :- public(can_spell/1).
    :- public(spell_no_spell/3).

    :- uses(character, [lower_upper/2, is_upper_case/1]).

    % public interface

    can_spell(Atom) :-
        atom_chars(Atom, Chars),
        to_lower(Chars, Lower),
        can_spell(_Block_Set_, Lower).

    spell_no_spell(Words, Spellable, Unspellable) :-
        meta::partition(can_spell, Words, Spellable, Unspellable).

    % local helper predicates

    can_spell(_, []).
    can_spell(Blocks0, [H|T]) :-
        ( list::selectchk(b(H,_), Blocks0, Blocks1)
        ; list::selectchk(b(_,H), Blocks0, Blocks1)
        ),
        can_spell(Blocks1, T).

    to_lower(Chars, Lower) :-
        meta::map(
            [C,L] >> (is_upper_case(C) -> lower_upper(L, C); C = L),
            Chars,
            Lower
        ).

:- end_object.
