-- imports
open import Data.Nat as ℕ     using (ℕ; suc; zero; _+_; _∸_)
open import Data.Vec as Vec   using (Vec; _∷_; []; tabulate; foldr)
open import Data.Fin as Fin   using (Fin; suc; zero)
open import Function          using (_∘_; const; id)
open import Data.List as List using (List; _∷_; [])
open import Data.Maybe        using (Maybe; just; nothing)

-- Without square cutoff optimization
module Simple where
  primes : ∀ n → List (Fin n)
  primes zero = []
  primes (suc zero) = []
  primes (suc (suc zero)) = []
  primes (suc (suc (suc m))) = sieve (tabulate (just ∘ suc))
    where
    sieve : ∀ {n} → Vec (Maybe (Fin (2 + m))) n → List (Fin (3 + m))
    sieve [] = []
    sieve (nothing ∷ xs) =         sieve xs
    sieve (just x  ∷ xs) = suc x ∷ sieve (foldr B remove (const []) xs x)
      where
      B = λ n → ∀ {i} → Fin i → Vec (Maybe (Fin (2 + m))) n

      remove : ∀ {n} → Maybe (Fin (2 + m)) → B n → B (suc n)
      remove _ ys zero    = nothing ∷ ys x
      remove y ys (suc z) = y       ∷ ys z

-- With square cutoff optimization
module SquareOpt where
  primes : ∀ n → List (Fin n)
  primes zero = []
  primes (suc zero) = []
  primes (suc (suc zero)) = []
  primes (suc (suc (suc m))) = sieve 1 m (Vec.tabulate (just ∘ Fin.suc ∘ Fin.suc))
    where
    sieve : ∀ {n} → ℕ → ℕ → Vec (Maybe (Fin (3 + m))) n → List (Fin (3 + m))
    sieve _ zero = List.mapMaybe id ∘ Vec.toList
    sieve _ (suc _) [] = []
    sieve i (suc l) (nothing ∷ xs) =     sieve (suc i) (l ∸ i ∸ i) xs
    sieve i (suc l) (just x  ∷ xs) = x ∷ sieve (suc i) (l ∸ i ∸ i) (Vec.foldr B remove (const []) xs i)
      where
      B = λ n → ℕ → Vec (Maybe (Fin (3 + m))) n

      remove : ∀ {i} → Maybe (Fin (3 + m)) → B i → B (suc i)
      remove _ ys zero    = nothing ∷ ys i
      remove y ys (suc j) = y       ∷ ys j
