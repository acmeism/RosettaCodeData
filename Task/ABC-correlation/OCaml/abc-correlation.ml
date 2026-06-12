(* Function to count number of occurrences of char `chr` in string `str`. *)
let count (chr : char) (str : string) : int
  = str |> String.to_seq |> Seq.filter ((=) chr) |> Seq.length

let main () : bool =
  (* Get input from command line arg... *)
  let input = Array.get Sys.argv 1 in
  (* ...count number of occurences of a, b, c in input... *)
  List.map ((|>) input) (List.map count ['a';'b';'c'])
  (* ...return whether they are all equal. *)
  |> (fun l -> List.for_all ((=) (List.hd l)) l)

(* Get and print result. *)
let () = Printf.printf "%b" @@ main ()
