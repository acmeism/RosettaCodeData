let is_prime (n : int) : bool =
  if n = 2 then true else if n < 2 || n mod 2 = 0 then false else
	let lim = (n |> float_of_int |> sqrt |> int_of_float) + 1 in
	let rec loop = function
		| i when i > lim -> true
		| i when n mod i = 0 -> false
		| i -> loop (i + 2)
	in loop 3

let char_list_of_string s = List.init (String.length s) (String.get s)

let commatize (str : string) : string =
  let revchars = List.rev (char_list_of_string str) in
  let rec take_threes = function
    | s, c1 :: c2 :: c3 :: rest ->
      take_threes ([c3; c2; c1] :: s, rest)
    | ss, rest -> if rest = [] then ss else List.rev rest :: ss
  in take_threes ([], List.map Char.escaped revchars)
  |> List.map (String.concat "") |> String.concat ","

let cube (n: int) : int = n * n * n

let scan_for_cubans (num : int) : int list =
  let rec loop = function
    | n, ps when List.length ps >= num -> ps
    | n, ps ->
      let c = cube (n + 1) - cube n in
      if is_prime c then loop (n + 1, c :: ps)
      else loop (n + 1, ps) in
  loop (1, []) |> List.rev

let nth_cuban (n : int) : int =
  let rec loop = function
    | i, c, p when c = n -> p
    | i, c, p ->
      let k = cube (i + 1) - cube i in
      if is_prime k then loop (i + 1, c + 1, k)
      else loop (i + 1, c, p) in
  loop (0, 0, 0)

let () =
  print_endline "The first 200 cuban primes are: ";
  scan_for_cubans 200
    |> List.map string_of_int
    |> List.map commatize
    |> String.concat " | "
    |> Printf.printf "[%s]\n\n";
  nth_cuban 100_000
    |> string_of_int
    |> commatize
    |> Printf.printf "The 100,000th cuban prime is %s\n"
