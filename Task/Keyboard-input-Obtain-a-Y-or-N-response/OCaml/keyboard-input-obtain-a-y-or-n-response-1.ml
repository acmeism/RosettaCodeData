let attrs = Unix.(tcgetattr stdin)
let buf = Bytes.create 1

let prompt switch =
    Unix.(tcsetattr stdin TCSAFLUSH)
      @@ if switch then { attrs with c_icanon = false } else attrs

let getchar () =
    let len = Unix.(read stdin) buf 0 1 in
      if len = 0 then raise End_of_file else Bytes.get buf 0
