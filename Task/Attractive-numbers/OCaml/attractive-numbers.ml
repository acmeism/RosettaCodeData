let is_prime (n : int) : bool =
  if n = 2 then true else if n < 2 || n mod 2 = 0 then false else
	let lim = (n |> float_of_int |> sqrt |> int_of_float) + 1 in
	let rec loop = function
		| i when i > lim -> true
		| i when n mod i = 0 -> false
		| i -> loop (i + 2)
	in loop 3

let prime_factors (n : int) : int list =
  let rec loop = function
    | factors, i, r when r = 1 -> factors
    | factors, i, r when is_prime i && r mod i = 0
      -> loop (i :: factors, i, r / i)
    | factors, i, r -> loop (factors, i+1, r)
  in loop ([], 2, n)

let is_attractive (n : int) : bool =
  n |> prime_factors |> List.length |> is_prime

let () =
  List.init 120 ((+) 1)
  |> List.filter is_attractive
  |> List.map string_of_int
  |> String.concat ","
  |> Printf.printf "[%s]"
