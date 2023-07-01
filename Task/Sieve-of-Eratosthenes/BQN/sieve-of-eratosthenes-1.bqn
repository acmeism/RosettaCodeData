Primes ← {
  𝕩≤2 ? ↕0 ;             # No primes below 2
  p ← 𝕊⌈√n←𝕩             # Initial primes by recursion
  b ← 2≤↕n               # Initial sieve: no 0 or 1
  E ← {↕∘⌈⌾((𝕩×𝕩+⊢)⁼)n}  # Multiples of 𝕩 under n, starting at 𝕩×𝕩
  / b E⊸{0¨⌾(𝕨⊸⊏)𝕩}´ p   # Cross them out
}
