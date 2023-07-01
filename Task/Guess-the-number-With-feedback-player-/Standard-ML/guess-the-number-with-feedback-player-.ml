structure GuessNumberHelper : MONO_ARRAY = struct
  type elem = order
  type array = int * int
  fun length (lo, hi) = hi - lo
  fun sub ((lo, hi), i) =
    let
      val n = lo + i
    in
      print ("My guess is: " ^ Int.toString (lo+i) ^ ". Is it too high, too low, or correct? (H/L/C) ");
      let
        val str = valOf (TextIO.inputLine TextIO.stdIn)
      in
        case Char.toLower (String.sub (str, 0)) of
          #"l" => GREATER
        | #"h" => LESS
        | #"c" => EQUAL
      end
    end

  (* dummy implementations for not-needed functions *)
  type vector = unit
  val maxLen = Array.maxLen
  fun update _ = raise Domain
  fun array _ = raise Domain
  fun fromList _ = raise Domain
  fun tabulate _ = raise Domain
  fun vector _ = raise Domain
  fun copy _ = raise Domain
  fun copyVec _ = raise Domain
  fun appi _ = raise Domain
  fun app _ = raise Domain
  fun modifyi _ = raise Domain
  fun modify _ = raise Domain
  fun foldli _ = raise Domain
  fun foldl _ = raise Domain
  fun foldri _ = raise Domain
  fun foldr _ = raise Domain
  fun findi _ = raise Domain
  fun find _ = raise Domain
  fun exists _ = raise Domain
  fun all _ = raise Domain
  fun collate _ = raise Domain
end

structure GuessNumberBSearch = BSearchFn (GuessNumberHelper)

val lower = 0
val upper = 100;

print ("Instructions:\n" ^
       "Think of integer number from " ^ Int.toString lower ^
       " (inclusive) to " ^ Int.toString upper ^ " (exclusive) and\n" ^
       "I will guess it. After each guess, you respond with L, H, or C depending\n" ^
       "on if my guess was too low, too high, or correct.\n");

case GuessNumberBSearch.bsearch (fn (_, x) => x) ((), (lower, upper)) of
  NONE => print "That is impossible.\n"
| SOME (result, _) => print ("Your number is " ^ Int.toString result ^ ".\n")
