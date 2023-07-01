numeric_string(String) :-
    atom_string(Atom, String),
    atom_number(Atom, _).
