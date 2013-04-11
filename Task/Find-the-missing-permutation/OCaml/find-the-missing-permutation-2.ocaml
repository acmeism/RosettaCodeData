let deficient_perms = [
  "ABCD";"CABD";"ACDB";"DACB";
  "BCDA";"ACBD";"ADCB";"CDAB";
  "DABC";"BCAD";"CADB";"CDBA";
  "CBAD";"ABDC";"ADBC";"BDCA";
  "DCBA";"BACD";"BADC";"BDAC";
  "CBDA";"DBCA";"DCAB";
  ]

let it = chars_of_string (List.hd deficient_perms)

let perms = List.map string_of_chars (permutations it)

let results = List.filter (fun v -> not(List.mem v deficient_perms)) perms

let () = List.iter print_endline results
