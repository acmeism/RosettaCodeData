MulInv←⊣|·⊑{0=𝕨?1‿0;(⌽-(0⋈𝕩⌊∘÷𝕨)⊸×)𝕨𝕊˜𝕨|𝕩}
ChRem←{
  num 𝕊 rem:
  prod←×´num
  prod|+´rem×(⊢×num⊸(MulInv¨))prod⌊∘÷num
}

•Show 3‿5‿7 ChRem 2‿3‿2
•Show 10‿4‿9 ChRem 11‿22‿19
