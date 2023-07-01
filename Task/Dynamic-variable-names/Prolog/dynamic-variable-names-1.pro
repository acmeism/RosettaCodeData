test :- read(Name), atomics_to_string([Name, "= 50, writeln('", Name, "' = " , Name, ")"], String), term_string(Term, String), Term.
