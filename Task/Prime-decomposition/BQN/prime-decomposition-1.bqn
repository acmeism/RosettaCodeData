Factor ← { 𝕊n:
  # Prime sieve
  primes ← ↕0
  Sieve ← { p 𝕊 a‿b:
    p(⍋↑⊣)↩√b ⋄ l←b-a
    E ← {↕∘⌈⌾(((𝕩|-a)+𝕩×⊢)⁼)l}        # Indices of multiples of 𝕩
    a + / (1⥊˜l) E⊸{0¨⌾(𝕨⊸⊏)𝕩}´ p     # Primes in segment [a,b)
  }
  # Factor by trial division
  r ← ↕0                              # Result list
  Try ← {
    m ← (1+⌊√n) ⌊ 2×𝕩                 # Upper bound for factors this round
    𝕩<m ?                             # Stop if no factors
    primes ∾↩ np ← primes Sieve 𝕩‿m   # New primes
    {0=𝕩|n? r∾↩𝕩 ⋄ n÷↩𝕩 ⋄ 𝕊𝕩 ;@}¨ np  # Try each one
    𝕊 m                               # Next segment
  ;@}
  Try 2
  r ∾ 1⊸<⊸⥊n
}
