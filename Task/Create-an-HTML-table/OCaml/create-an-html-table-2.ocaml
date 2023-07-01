open XHTML.M_01_01

let _td s = td [pcdata s]
let _th s = th [pcdata s]

let my_table =
  table ~a:[a_border 1]
    (tr
      (_th "") [
      (_th "X");
      (_th "Y");
      (_th "Z")]
    )
  [
    (tr
      (_td "1") [
      (_td "aa");
      (_td "bb");
      (_td "cc")]
    );
    (tr
      (_td "2") [
      (_td "dd");
      (_td "ee");
      (_td "ff")]
    );
  ]

let my_page =
  html
    (head (title (pcdata "My Page")) [])
    (body
      [ h1 [pcdata "My Table"];
        my_table;
      ]
    )

let () =
  pretty_print ~width:80 print_string my_page
