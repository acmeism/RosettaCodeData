fun char2value c =
  if List.exists (fn x => x = c) (explode "AEIOU") then raise Fail "no vowels"
  else if Char.isDigit c then ord c - ord #"0"
  else if Char.isUpper c then ord c - ord #"A" + 10
  else raise Match

val sedolweight = [1,3,1,7,3,9]

fun checksum sedol = let
  val tmp = ListPair.foldlEq (fn (ch, weight, sum) => sum + char2value ch * weight)
              0 (explode sedol, sedolweight)
in
  Int.toString ((10 - (tmp mod 10)) mod 10)
end

app (fn sedol => print (sedol ^ checksum sedol ^ "\n"))
  [ "710889",
    "B0YBKJ",
    "406566",
    "B0YBLH",
    "228276",
    "B0YBKL",
    "557910",
    "B0YBKR",
    "585284",
    "B0YBKT" ];
