let (-->) = bind
let (let*) = bind

let print_str_opt x =
  Format.printf "%s" (Option.value ~default:"None" x)
