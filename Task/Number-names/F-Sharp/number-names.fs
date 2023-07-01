let divMod n d = n / d, n % d

let join = String.concat ", "

let rec nonzero = function
  | _, 0 -> ""
  | c, n -> c + (spellInteger n)

and tens n =
  [| ""; ""; "twenty"; "thirty"; "forty"; "fifty";
             "sixty"; "seventy"; "eighty"; "ninety" |].[n]

and small n =
  [| "zero"; "one"; "two"; "three"; "four"; "five";
     "six"; "seven"; "eight"; "nine"; "ten"; "eleven";
     "twelve"; "thirteen"; "fourteen"; "fifteen";
     "sixteen";"seventeen"; "eighteen"; "nineteen" |].[n]

and bl = [| ""; ""; "m"; "b"; "tr"; "quadr"; "quint";
                    "sext"; "sept"; "oct"; "non"; "dec" |]

and big = function
  | 0, n -> (spellInteger n)
  | 1, n -> (spellInteger n) + " thousand"
  | e, n -> (spellInteger n) + " " + bl.[e] + "illion"

and uff acc = function
  | 0 -> List.rev acc
  | n ->
      let a, b = divMod n 1000
      uff (b::acc) a

and spellInteger = function
  | n when n < 0 -> "minus " + spellInteger (abs n)
  | n when n < 20 -> small n
  | n when n < 100 ->
      let a, b = divMod n 10
      (tens a) + nonzero ("-", b)
  | n when n < 1000 ->
      let a, b = divMod n 100
      (small a) + " hundred" + nonzero (" ", b)
  | n ->
      let seg = uff [] n
      let _, segn =
        (* just add the index of the item in the list *)
        List.fold
          (fun (i,acc) v -> i + 1, (i, v)::acc)
          (0, [])
          seg

      let fsegn =
        (* remove right part "zero" *)
        List.filter
          (function (_, 0) -> false | _ -> true)
          segn

      join (List.map big fsegn)
;;
