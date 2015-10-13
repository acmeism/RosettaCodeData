type CIS<'T> = struct val v: 'T val cont: unit -> CIS<'T> new(v,cont) = {v=v;cont=cont} end
type Prime = uint32
let frstprm = 2u
let frstoddprm = 3u
let inc1 = 1u
let inc = 2u
