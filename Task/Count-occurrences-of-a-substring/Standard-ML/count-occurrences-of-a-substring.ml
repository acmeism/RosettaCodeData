fun count_substrings (str, sub) =
  let
    fun aux (str', count) =
      let
        val suff = #2 (Substring.position sub str')
      in
        if Substring.isEmpty suff then
       	  count
        else
          aux (Substring.triml (size sub) suff, count + 1)
      end
  in
    aux (Substring.full str, 0)
  end;

print (Int.toString (count_substrings ("the three truths", "th")) ^ "\n");
print (Int.toString (count_substrings ("ababababab", "abab")) ^ "\n");
print (Int.toString (count_substrings ("abaabba*bbaba*bbab", "a*b")) ^ "\n");
