module Array = struct
  include Array
  (* Computes: f a.(0) + f a.(1) + ... where + is 'g'. *)
  let foldmap g f a =
    let n = Array.length a in
    let rec aux acc i =
      if i >= n then acc else aux (g acc (f a.(i))) (succ i)
    in aux (f a.(0)) 1

  (* like the stdlib fold_left, but also provides index to f *)
  let foldi_left f x a =
    let r = ref x in
    for i = 0 to length a - 1 do
      r := f i !r (unsafe_get a i)
    done;
    !r
end

let foldmap_range g f (a,b) =
  let rec aux acc n =
    let n = succ n in
    if n > b then acc else aux (g acc (f n)) n
  in aux (f a) a

let fold_range f init (a,b) =
  let rec aux acc n =
    if n > b then acc else aux (f acc n) (succ n)
  in aux init a
