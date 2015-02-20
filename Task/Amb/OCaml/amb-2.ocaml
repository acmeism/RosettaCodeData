let set_1 = [| "the"; "that"; "a" |]
let set_2 = [| "frog"; "elephant"; "thing" |]
let set_3 = [| "walked"; "treaded"; "grows" |]
let set_4 = [| "slowly"; "quickly" |]

let comb_search p aa =
  let nx = Array.make (Array.length aa) 0 in
  let lx = Array.map Array.length aa in
  let la = Array.length aa in
  let rec loop() =
    let res = Array.mapi (fun i j -> aa.(i).(j)) nx in
    if p res then (res)
    else
    ( nx.(0) <- nx.(0) + 1;
      if nx.(0) < lx.(0)
      then loop()
      else
      ( nx.(0) <- 0;
        let rec roll n =
          if n >= la then raise Not_found
          else
          ( nx.(n) <- nx.(n) + 1;
            if nx.(n) >= lx.(n)
            then ( nx.(n) <- 0; roll (n+1) )
            else loop()
          )
        in
        roll 1
      )
    )
  in
  loop()

let last s = s.[pred(String.length s)]
let joined a b = (last a = b.[0])

let rec test = function
  | a::b::tl -> (joined a b) && (test (b::tl))
  | _ -> true

let test r = test(Array.to_list r)

let print_set set =
  Array.iter (Printf.printf " %s") set;
  print_newline();
;;

let () =
  let result = comb_search test [| set_1; set_2; set_3; set_4 |] in
  print_set result;
;;
