local
  fun quib []      = ""
    | quib [x]     = x
    | quib [x0,x1] = x0 ^ " and " ^ x1
    | quib (x::xs) = x ^ ", " ^ quib xs
in
  fun quibble xs = "{" ^ quib xs ^ "}"
end

(* Tests: *)
val t_quibble_0 = quibble [] = "{}"
val t_quibble_1 = quibble ["ABC"] = "{ABC}"
val t_quibble_2 = quibble ["ABC", "DEF"] = "{ABC and DEF}"
val t_quibble_3 = quibble ["ABC", "DEF", "G", "H"] = "{ABC, DEF, G and H}"
