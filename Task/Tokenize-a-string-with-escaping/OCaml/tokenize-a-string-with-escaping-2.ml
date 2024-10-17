let res = split_with_escaping ~esc:'^' ~sep:'|' "one^|uno||three^^^^|four^^^|^cuatro|";;
val res : string list = ["one|uno"; ""; "three^^"; "four^|cuatro"; ""]
