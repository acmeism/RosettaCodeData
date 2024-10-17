(*  Task : Generator/Exponential

    Version using the Seq module types, but transparently
*)

(*** Helper functions ***)

(* Generator type *)
type 'a gen = unit -> 'a node
and 'a node = Nil | Cons of 'a * 'a gen

(* Power function on integers *)
let power (base : int) (exp : int) : int =
    let rec helper exp acc =
        if exp = 0 then acc
        else helper (exp - 1) (base * acc)
    in
    helper exp 1

(* Take (at most) n from generator *)
let rec take (n : int) (gen : 'a gen) : 'a list =
    if n = 0 then []
    else
        match gen () with
        | Nil -> []
        | Cons (x, tl) -> x :: take (n - 1) tl

(* Stop existing generator at a given condition *)
let rec keep_while (p : 'a -> bool) (gen : 'a gen) : 'a gen = fun () ->
    match gen () with
    | Nil -> Nil
    | Cons (x, tl) ->
        if p x then Cons (x, keep_while p tl)
        else Nil

(* Drop the first n elements of a generator *)
let rec drop (n : int) (gen : 'a gen) : 'a gen =
    if n = 0 then gen
    else
    match gen () with
    | Nil -> (fun () -> Nil)
    | Cons (_, tl) -> drop (n - 1) tl

(* Filter based on predicate, lazily *)
let rec filter (p : 'a -> bool) (gen : 'a gen) : 'a gen = fun () ->
    match gen () with
    | Nil -> Nil
    | Cons (x, tl) ->
        if p x then Cons (x, filter p tl)
        else filter p tl ()

(* Is this value inside this generator? Does not terminate for infinite streams! *)
let rec mem (val_ : 'a) (gen : 'a gen) : bool =
    match gen () with
    | Nil -> false
    | Cons (x, tl) ->
        if x = val_ then true
        else mem val_ tl

(*** Task at hand ***)

(*  Create a function that returns a generation of the m'th powers of the positive integers
    starting from zero, in order, and without obvious or simple upper limit.
    (Any upper limit to the generator should not be stated in the source but should be down
    to factors such as the languages natural integer size limit or computational time/size).
*)
let power_gen k : int gen =
    let rec generator n () =
        Cons (power n k, generator (n + 1))
    in
    generator 0

(* Use it to create generators of squares and cubes *)
let squares = power_gen 2
let cubes = power_gen 3

(* Create a new generator that filters all cubes from the generator of squares. *)
let squares_no_cubes =
    let filter_p square =
        (* Get all cubes up to square *)
        let cubes_up_to_n2 = keep_while ((>=) square) cubes in
        not (mem square cubes_up_to_n2)
    in
    filter filter_p squares

(*** Output ***)

(* Drop the first 20 values from this last generator of filtered results, and then show the next 10 values. *)
let _ =
    squares_no_cubes |> drop 20 |> take 10
