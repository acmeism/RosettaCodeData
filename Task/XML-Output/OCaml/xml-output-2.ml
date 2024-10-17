#directory "+xmlm"
#load "xmlm.cmo"
open Xmlm

let datas = [
    ("April", "Bubbly: I'm > Tam and <= Emily");
    ("Tam O'Shanter", "Burns: \"When chapman billies leave the street ...\"");
    ("Emily", "Short & shrift");
  ]

let xo = make_output (`Channel stdout)

let () =
  output xo (`Dtd None);
  output xo (`El_start (("", "CharacterRemarks"), []));
  List.iter (fun (name, content) ->
      output xo (`El_start (("", "Character"), [(("", "name"), name)]));
      output xo (`Data content);
      output xo (`El_end);
  ) datas;
  output xo (`El_end);
  print_newline()
