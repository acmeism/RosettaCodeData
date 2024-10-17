open Ctypes
open Foreign

let myfunc_a = foreign "myfunc_a" (void @-> returning void)
let myfunc_b = foreign "myfunc_b" (int @-> float @-> returning float)
let myfunc_c = foreign "myfunc_c" (ptr void @-> int @-> returning string)

let myfunc_c lst =
  let arr = CArray.of_list int lst in
  myfunc_c (to_voidp (CArray.start arr)) (CArray.length arr)
;;
