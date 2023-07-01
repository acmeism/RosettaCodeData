let make_table () =
  let br = X.a_border 1 in
  let th s = X.th [X.pcdata s] in
  let td s = X.td [X.pcdata s] in
  let my_thead = X.thead (X.tr (th "") [th "X"; th "Y"; th "Z"]) [] in
  let my_tr1 = X.tr (td "1") [td "AAA"; td "BBB"; td "CCC"] in
  let my_tr2 = X.tr (td "2") [td "DDD"; td "EEE"; td "FFF"] in
  let my_tr3 = X.tr (td "3") [td "GGG"; td "HHH"; td "III"] in
  let my_tbody = X.tbody my_tr1 [my_tr2; my_tr3] in
  let my_table = X.tablex ~thead:my_thead ~a:[br] my_tbody [] in
  (my_table)
