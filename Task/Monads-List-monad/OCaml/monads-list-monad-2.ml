let (>>) = bind (* operator for inline binding *)
let (let*) = bind (* let pruning for easy bind *)

let print_str_list l =
    Format.printf "[%a]" (fun fmt -> Format.pp_print_list Format.pp_print_string fmt) l
