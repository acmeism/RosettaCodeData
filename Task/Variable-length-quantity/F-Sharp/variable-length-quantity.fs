let to_vlq n =
  let a, b = n >>> 7, n &&& 0x7F
  let rec aux n acc =
    let x,xs = (n &&& 0x7F) ||| 0x80, n >>> 7
    if xs > 0 then aux xs (x::acc) else x::acc
  aux a [b]

let to_num = List.fold (fun n x -> (n <<< 7) + (x &&& 0x7F)) 0

let v_rep n =
  let seq = to_vlq n
  printf "%d ->" n
  List.iter (printf " 0x%02X") seq
  printfn " -> %d" (to_num seq)

v_rep 0x200000
v_rep 0x1FFFFF
