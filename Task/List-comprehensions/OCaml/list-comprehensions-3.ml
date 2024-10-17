let (let*) xs f = List.concat_map f xs
let (--) a b = List.init (b-a+1) ((+)a)
