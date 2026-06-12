def conjugate:
  if endswith("are") | not
  then "\(.) is not a first conjugation verb." | error
  else .[0:-3] as $stem
  | if $stem|length == 0 then "Stem cannot be empty." | error
    else "Present indicative tense of '\(.)':",
        ( "o", "as", "at", "amus", "atis", "ant"
         | "  " + $stem + .),
	""
    end
  end;

("amare", "dare")
| conjugate
