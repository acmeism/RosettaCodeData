let () =
  print_endline "\
\\documentclass{report}
\\usepackage{fullpage}
\\begin{document}
  \\begin{tabular}{ r | *{120}{c} }";

  List.iter (fun key ->
    Printf.printf "    %d" key;
    let vs = List.filter (fun (a,_) -> a = key) data in
    let vs = List.sort compare (List.map snd vs) in
    List.iter (Printf.printf " & %d") vs;
    print_endline " \\\\"
  ) keys;

  print_endline "\
  \\end{tabular}
\\end{document}"
