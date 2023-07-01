# Function that returns a new prime generator
PrimeGen ← {𝕤
  i ← 0  # Counter: index of next prime to be output
  primes ← ↕0
  next ← 2
  Sieve ← { p 𝕊 i‿n:
    E ← {↕∘⌈⌾(((𝕩|-i)+𝕩×⊢)⁼)n-i}       # Indices of multiples of 𝕩
    i + / (1⥊˜n-i) E⊸{0¨⌾(𝕨⊸⊏)𝕩}´ p    # Primes in segment [i,n)
  }
  {𝕤
    { i=≠primes ?                      # Extend if required
      next ↩ ((2⋆24)⊸+ ⌊ ×˜) old←next  # Sieve at most 16M new entries
      primes ∾↩ (primes(⍋↑⊣)√next) Sieve old‿next
    ;@}
    (i+↩1) ⊢ i⊑primes
  }
}
_w_←{𝔽⍟𝔾∘𝔽_𝕣_𝔾∘𝔽⍟𝔾𝕩}  # Looping utility for the session below
