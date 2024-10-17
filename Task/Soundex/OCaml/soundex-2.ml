let tests = [
  "Soundex",     "S532";
  "Example",     "E251";
  "Sownteks",    "S532";
  "Ekzampul",    "E251";
  "Euler",       "E460";
  "Gauss",       "G200";
  "Hilbert",     "H416";
  "Knuth",       "K530";
  "Lloyd",       "L300";
  "Lukasiewicz", "L222";
  "Ellery",      "E460";
  "Ghosh",       "G200";
  "Heilbronn",   "H416";
  "Kant",        "K530";
  "Ladd",        "L300";
  "Lissajous",   "L222";
  "Wheaton",     "W350";
  "Ashcraft",    "A226";
  "Burroughs",   "B622";
  "Burrows",     "B620";
  "O'Hara",      "O600";
  ]

let () =
  print_endline " Word   \t Code  Found Status";
  List.iter (fun (word, code1) ->
    let code2 = soundex word in
    let status = if code1 = code2 then "OK " else "Arg" in
    Printf.printf " \"%s\" \t %s  %s  %s\n" word code1 code2 status
  ) tests
