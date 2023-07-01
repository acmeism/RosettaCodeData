test_strings(Strings) :-
    forall( member(String, Strings),
            ( ( numeric_string(String)
              ->  Result = a
              ;   Result = 'not a' ),
              format('~w is ~w number.~n', [String, Result])
            )
          ).
