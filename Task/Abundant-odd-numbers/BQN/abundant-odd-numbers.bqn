Divisors ← {
  n ← 𝕩 ⋄ r ← ⌊√n
  lower ← 1 + /0 = (1↓↕r+1)|¨n
  upper ← {n ÷ 𝕩}¨lower
  lower ∾ (n = r⋆2)↓⌽upper
}

Proper ← {(-𝕩) +´ Divisors 𝕩}
Abundant ← {𝕩 < Proper 𝕩}

kap ← 250_000 # number of candidates to test
a ← 1+2×/Abundant¨1+2×↕kap

•Out "The first 25 abundant odd numbers:"
{•Out (•Fmt 𝕩)∾"; proper sum: "∾•Fmt Proper 𝕩}¨25↑a

•Out "The 1000th: "∾(•Fmt 999 ⊑ a)∾"; proper sum: "∾•Fmt Proper 999 ⊑ a

big ← {𝕩+2} •_while_(¬Abundant) 1000000001
•Out "The first > 1e9: " ∾(•Fmt big)∾"; proper sum: "∾•Fmt Proper big
