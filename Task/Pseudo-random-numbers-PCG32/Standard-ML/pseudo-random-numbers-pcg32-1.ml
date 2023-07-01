type pcg32 = LargeWord.word * LargeWord.word

local
  infix 5 >>
  val op >> = LargeWord.>>
  and m = 0w6364136223846793005 : LargeWord.word
  and rotate32 = fn a as (x, n) =>
    Word32.orb (Word32.>> a, Word32.<< (x, Word.andb (~ n, 0w31)))
in
  fun pcg32Init (seed, seq) : pcg32 =
    let
      val inc = LargeWord.<< (LargeWord.fromInt seq, 0w1) + 0w1
    in
      ((LargeWord.fromInt seed + inc) * m + inc, inc)
    end
  fun pcg32Random ((state, inc) : pcg32) : Word32.word * pcg32 = (
    rotate32 (
      Word32.xorb (
        Word32.fromLarge (state >> 0w27),
        Word32.fromLarge (state >> 0w45)),
      Word.fromLarge (state >> 0w59)),
    (state * m + inc, inc))
end
