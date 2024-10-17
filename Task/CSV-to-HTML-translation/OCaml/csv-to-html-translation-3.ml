open Printf

let csv_data = "\
Character,Speech
The multitude,The messiah! Show us the messiah!
Brians mother,<angry>Now you listen here! He's not the messiah; \
              he's a very naughty boy! Now go away!</angry>
The multitude,Who are you?
Brians mother,I'm his mother; that's who!
The multitude,Behold his mother! Behold his mother!"

(* General HTML escape *)
let escape =
  let html_escapes = Str.regexp "\\([^A-Za-z0-9 ;!?'/]\\)" in
  let esc s = sprintf "&#%04d;" (Char.code s.[Str.group_beginning 1]) in
  Str.global_substitute html_escapes esc

let nl = Str.regexp "\n\r?"
let coma = Str.regexp ","

let list_of_csv csv =
  List.map (fun l -> Str.split coma l) (Str.split nl csv)

let print_html_table segments =
  let print_row line =
    printf "<tr>";
    List.iter (fun c -> printf "<td>%s</td>" (escape c)) line;
    printf "</tr>\n" in
  printf "<html>
  <head>
    <style type=\"text/css\">
      td {background-color:#ddddff; }
      thead td {background-color:#ddffdd; text-align:center; }
    </style>
  </head>";
  printf "<table>\n<thead>";
  print_row (List.hd segments);
  printf "</thead><tbody>\n";
  List.iter print_row (List.tl segments);
  printf "</tbody>\n</table>\n</html>";
;;

let () =
  print_html_table (list_of_csv csv_data)
