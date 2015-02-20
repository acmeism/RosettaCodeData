(* Useful rule declaration: "cond => f", 'cond'itionally applies 'f' to 'a'ccumulated value *)
let (=>) cond f a = if cond then f a else a
let append s a = a^s

let fizzbuzz i =
  "" |> (i mod 3 = 0 => append "Fizz")
     |> (i mod 5 = 0 => append "Buzz")
     |> (function "" -> string_of_int i
                | s  -> s)
