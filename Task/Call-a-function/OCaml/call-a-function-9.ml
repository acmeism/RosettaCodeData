let ret = f ()
let a, b, c = f ()  (* if there are several returned values given as a tuple *)
let _ = f ()        (* if we want to ignore the returned value *)
let v, _ = f ()     (* if we want to ignore one of the returned value *)
