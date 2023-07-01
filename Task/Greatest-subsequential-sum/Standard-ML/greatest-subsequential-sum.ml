val maxsubseq = let
  fun loop (_, _, maxsum, maxseq) [] = (maxsum, rev maxseq)
    | loop (sum, seq, maxsum, maxseq) (x::xs) = let
        val sum = sum + x
        val seq = x :: seq
      in
        if sum < 0 then
          loop (0, [], maxsum, maxseq) xs
        else if sum > maxsum then
          loop (sum, seq, sum, seq) xs
        else
          loop (sum, seq, maxsum, maxseq) xs
      end
in
  loop (0, [], 0, [])
end;

maxsubseq [~1, ~2, 3, 5, 6, ~2, ~1, 4, ~4, 2, ~1]
