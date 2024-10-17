#load "str.cma"


(* We are going to use literally a list of records as said in the title of the
 * task. *)
(* First: Definition of the record type. *)
type city = {
  name : string;
  population : float
}

(* Second: The actual list of records containing the data. *)
let cities = [
  { name = "Lagos";                population = 21.0  };
  { name = "Cairo";                population = 15.2  };
  { name = "Kinshasa-Brazzaville"; population = 11.3  };
  { name = "Greater Johannesburg"; population =  7.55 };
  { name = "Mogadishu";            population =  5.85 };
  { name = "Khartoum-Omdurman";    population =  4.98 };
  { name = "Dar Es Salaam";        population =  4.7  };
  { name = "Alexandria";           population =  4.58 };
  { name = "Abidjan";              population =  4.4  };
  { name = "Casablanca";           population =  3.98 }
]


(* I can't find in the standard library any function in module List that returns
 * an index. Well, never mind, I make my own... *)
let find_index pred =
  let rec doloop i = function
    | [] -> raise Not_found
    | x :: xs -> if pred x then i else doloop (i + 1) xs
  in
  doloop 0


(* List.find returns the first element that satisfies the predicate.
 * List.filter or List.find_all would return *all* the elements that satisfy the
 * predicate. *)
let get_first pred = List.find pred


(* Simulate the 'startswith' function found in other languages. *)
let startswith sub s =
  Str.string_match (Str.regexp sub) s 0


let () =
  (* We use a typical dot notation to access the record fields. *)
  find_index (fun c -> c.name = "Dar Es Salaam") cities
  |> print_int
  |> print_newline;

  (get_first (fun c -> c.population < 5.0) cities).name
  |> print_endline;

  (get_first (fun c -> startswith "A" c.name) cities).population
  |> print_float
  |> print_newline;
