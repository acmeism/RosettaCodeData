let sum i lo hi term =
  let temp = ref 0. in
  for n = lo to hi do i := n;
      temp := !temp +. term()
  done;
  !temp

let () =
  let i = ref 1 in
  print_float (sum i 1 100 (fun () -> 1. /. float !i))
