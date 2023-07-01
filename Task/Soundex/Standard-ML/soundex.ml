(* There are 3 kinds of letters:
 *   h and w are ignored completely (letters separated by h or w are considered
 *     adjacent, or merged together)
 *   vowels are ignored, but letters separated by a vowel are split apart.
 *   All consonants but h and w map to a digit *)
datatype code =
         Merge
       | Split
       | Digit of char

(* Encodes which characters map to which codes *)
val codeTable =
 [([#"H", #"W"], Merge),
  ([#"A",#"E",#"I", #"O",#"U",#"Y"], Split),
  ([#"B",#"F",#"P",#"V"], Digit #"1"),
  ([#"C",#"G",#"J",#"K",#"Q",#"S",#"X",#"Z"], Digit #"2"),
  ([#"D",#"T"], Digit #"3"),
  ([#"L"], Digit #"4"),
  ([#"M",#"N"], Digit #"5"),
  ([#"R"], Digit #"6")]

(* Find the code that matches a given character *)
fun codeOf (c : char) =
    #2 (valOf (List.find (fn (L,_) => isSome(List.find (fn c' => c = c') L)) codeTable))

(* Remove all the non-digit codes, combining like digits when appropriate. *)
fun collapse (c :: Merge :: cs) = collapse (c :: cs)
  | collapse (Digit d :: Split :: cs) = Digit d :: collapse cs
  | collapse (Digit d :: (cs' as Digit d' :: cs)) =
    if d = d' then collapse (Digit d :: cs)
    else Digit d :: collapse cs'
  | collapse [Digit d] = [Digit d]
  | collapse (c::cs) = collapse cs
  | collapse _ = []

(* dropWhile f L removes the initial elements of L that satisfy f and returns
 * the rest *)
fun dropWhile f [] = []
  | dropWhile f (x::xs) =
    if f x then dropWhile f xs
    else x::xs

fun soundex (s : string) =
    let
      (* Normalize the string to uppercase letters only *)
      val c::cs = map (Char.toUpper) (filter Char.isAlpha(String.explode s))
      fun first3 L = map (fn Digit c => c) (List.take(L,3))
      val padding = [Digit #"0", Digit #"0", Digit #"0"]
      (* Remove any initial section that has the same code as the first character.
       * This comes up in the "Pfister" test case. *)
      val codes = dropWhile (fn Merge => true | Digit d => Digit d = codeOf c | Split => false)
                            (map codeOf (c::cs))
    in
      String.implode(c::first3(collapse codes@padding))
    end

(* Some test cases from Wikipedia *)
fun test input output =
    if soundex input = output then ()
    else raise Fail ("Soundex of " ^ input ^ " should be " ^ output ^ ", not " ^ soundex input)

val () = test "Rupert" "R163"
val () = test "Robert" "R163"
val () = test "Rubin" "R150"
val () = test "Tymczak" "T522"
val () = test "Pfister" "P236"
