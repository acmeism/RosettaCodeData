#use "topfind"
#require "tyxml"

module X = Xhtml.M_01_01  (* XHTML 1.1 *)
module P = Xhtml.P_01_01

let make_table () =
  let td1 = X.td [X.pcdata "1"] in
  let td2 = X.td [X.pcdata "2"] in
  let td3 = X.td [X.pcdata "3"] in
  let my_tr = X.tr td1 [td2; td3] in
  let my_table = X.table my_tr [] in
  (my_table)

let () =
  let my_title = X.title (X.pcdata "My Page") in
  let my_head = X.head my_title [] in
  let my_h1 = X.h1 [X.pcdata "My Table"] in

  let my_table = make_table () in

  let my_body = X.body [my_h1; my_table] in
  let my_html = X.html my_head my_body in
  P.print print_endline my_html;
;;
