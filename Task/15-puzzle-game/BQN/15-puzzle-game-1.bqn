_while_ ← {𝔽⍟𝔾∘𝔽_𝕣_𝔾∘𝔽⍟𝔾𝕩}
FPG←{
  𝕊𝕩: 4‿4𝕊𝕩;
  (∧´𝕨<0)∨2≠≠𝕨 ? •Out "Invalid shape: "∾•Fmt 𝕨;
  0≠=𝕩 ? •Out "Invalid shuffle count: "∾•Fmt 𝕩;
  s𝕊𝕩:
  d←⟨1‿0⋄¯1‿0⋄0‿1⋄0‿¯1⟩ # Directions
  w←𝕨⥊1⌽↕×´𝕨 # Solved grid
  b←w        # Board
  z←⊑{
    z‿p←𝕩
    p↩(⊢≡s⊸|)¨⊸/(<z)+d(¬∘∊/⊣)p # filter out invalid
    n←(•rand.Range ≠p)⊑p
    b⌽⌾(z‿n⊸⊑)↩ # switch places
    -`n‿z
  }⍟𝕩 ⟨𝕨-1,⟨0⟩⟩
  {
    𝕊:
    b≡w ? •Show b, •Out "You win", 0;
    •Show b
    inp←⊑{
      Check 𝕩:
      •Out "Enter move: "
      x←•GetLine@
      i←⊑"↑↓←→q"⊐x
      {
        i=4 ? i; # quit
        i>4 ? •Out "Invalid direction: "∾x, Check x;
        (⊢≢s⊸|)z+i⊑d ? •Out "Out of bounds: "∾x, Check x;
        i
      }
    } @
    {
      𝕩=4 ? •Out "Quitting", 0;
      mv←z+𝕩⊑d
      b⌽⌾(mv‿z⊸⊑)↩
      z↩mv
      1
    } inp
  } _while_ ⊢ 1
  @
}
