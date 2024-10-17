replace("nowhere ABJURER", r"[A-Za-z]" => s -> map(c -> c + (uppercase(c) < 'N' ? 13 : -13), s))
