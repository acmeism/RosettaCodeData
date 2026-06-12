module PeanoArithmetic where

-- 1.1. The natural numbers.
--
--   ℕ-formation:     ℕ is set.
--
--   ℕ-introduction:  zero ∈ ℕ,
--                    a ∈ ℕ | (suc a) ∈ ℕ.
--
data ℕ : Set where
  zero : ℕ
  suc  : (n : ℕ) → ℕ

-- 1.2. The even natural numbers.
--
data 2×ℕ : ℕ → Set where
  zero₁ : 2×ℕ zero
  2+_  : {m : ℕ} → 2×ℕ m → 2×ℕ (suc (suc m) )

-- 1.3. The odd natural numbers.
--
data 2×ℕ+1 : ℕ → Set where
  one : 2×ℕ+1 (suc zero)
  2+₁_ : {m : ℕ} → 2×ℕ+1 m → 2×ℕ+1 (suc (suc m) )

-- 2.1. The rule of addition.
--
--   via ℕ-elimination.
--
infixl 6 _+_
_+_ : (k : ℕ) → (n : ℕ) → ℕ
zero    + n = n
(suc m) + n = suc (m + n)

-- 3.1. Sum of any two even numbers is even.
--
--   This function takes any two even numbers and returns their sum as an even
--   number, this is the type, i.e. logical proposition, algorithm itself is a
--   proof which builds a required term of a given (inhabited) type, and the
--   typechecker performs that proof (by unification, so that this is a form of
--   compile-time verification).
--
even+even≡even : {m n : ℕ} → 2×ℕ m → 2×ℕ n → 2×ℕ (m + n)
even+even≡even zero₁  n = n
even+even≡even (2+ m) n = 2+ (even+even≡even m n)

-- The identity type (for propositional equality).
--
infix 4 _≡_
data _≡_ {A : Set} (m : A) : A → Set where
  refl : m ≡ m

sym : {A : Set} → {m n : A} → m ≡ n → n ≡ m
sym refl = refl

trans : {A : Set} → {m n p : A} → m ≡ n → n ≡ p → m ≡ p
trans refl n≡p = n≡p

-- refl, sym and trans forms an equivalence relation.

cong : {A B : Set} → (f : A → B) → {m n : A} → m ≡ n → f m ≡ f n
cong f refl = refl

-- 3.2.1. Direct proof of the associativity of addition using propositional
-- equality.
--
+-associative : (m n p : ℕ) → (m + n) + p ≡ m + (n + p)
+-associative zero    _ _ = refl
+-associative (suc m) n p = cong suc (+-associative m n p)

-- Proof _of_ mathematical induction on the natural numbers.
--
--   P 0, ∀ x. P x → P (suc x) | ∀ x. P x.
--
ind : (P : ℕ → Set) → P zero → ((m : ℕ) → P m → P (suc m)) → (m : ℕ) → P m
ind _ P₀ _    zero    = P₀
ind P P₀ next (suc n) = next n (ind P P₀ next n)

-- 3.2.2. The associativity of addition by induction (with propositional
-- equality, again).
--
+-associative′ : (m n p : ℕ) → (m + n) + p ≡ m + (n + p)
+-associative′ m n p = ind P P₀ is m
  where
    P : ℕ → Set
    P m = m + n + p ≡ m + (n + p)
    P₀ : P zero
    P₀ = refl
    is : (m : ℕ) → P m → P (suc m)
    is _ Pi = cong suc Pi

-- Syntactic sugar for equational reasoning (we don't use preorders here).

infix 4 _≋_
data _≋_ (m n : ℕ) : Set where
  refl₁ : m ≡ n → m ≋ n

infix 1 begin_
begin_ : {m n : ℕ} → m ≋ n → m ≡ n
begin (refl₁ m≡n) = m≡n

infixr 2 _~⟨_⟩_
_~⟨_⟩_ : (m : ℕ){n p : ℕ} → m ≡ n → n ≋ p → m ≋ p
_ ~⟨ m≡n ⟩ (refl₁ n≡p) = refl₁ (trans m≡n n≡p)

infix 3 _∎
_∎ : (m : ℕ) → m ≋ m
_∎ _ = refl₁ refl


-- Some helper proofs.

m+0≡m : (m : ℕ) → m + zero ≡ m
m+0≡m zero    = refl
m+0≡m (suc m) = cong suc (m+0≡m m)

m+1+n≡1+m+n : (m n : ℕ) → m + (suc n) ≡ suc (m + n)
m+1+n≡1+m+n zero    n = refl
m+1+n≡1+m+n (suc m) n = cong suc (m+1+n≡1+m+n m n)

-- 3.3. The commutativity of addition using equational reasoning.
--
+-commutative : (m n : ℕ) → m + n ≡ n + m
+-commutative zero    n = sym (m+0≡m n)
+-commutative (suc m) n =
    begin
      suc m + n
    ~⟨ refl ⟩
      suc (m + n)
    ~⟨ cong suc (+-commutative m n) ⟩
      suc (n + m)
    ~⟨ sym (m+1+n≡1+m+n n m) ⟩
      n + suc m
    ∎

-- 3.4.
--
even+even≡odd : {m n : ℕ} → 2×ℕ m → 2×ℕ n → 2×ℕ+1 (m + n)
even+even≡odd zero₁ zero₁ = {!!}
even+even≡odd _    _     = {!!}
-- ^
-- That gives
--
--   ?0 : 2×ℕ+1 (zero + zero)
--   ?1 : 2×ℕ+1 (m + n)
--
-- but 2×ℕ+1 (zero + zero) = 2×ℕ+1 0 which is uninhabited, so that this proof
-- can not be writen.
--

-- The absurd (obviously uninhabited) type.
--
--   ⊥-introduction is empty.
--
data ⊥ : Set where

-- The negation of a proposition.
--
infix  6 ¬_
¬_ : Set → Set
¬ A = A → ⊥

-- 4.1. Disproof or proof by contradiction.
--
--   To disprove even+even≡odd we assume that even+even≡odd and derive
--   absurdity, i.e. uninhabited type.
--
even+even≢odd : {m n : ℕ} → 2×ℕ m → 2×ℕ n → ¬ 2×ℕ+1 (m + n)
even+even≢odd zero₁   zero₁   ()
even+even≢odd zero₁   (2+ n) (2+₁ m+n) = even+even≢odd zero₁ n m+n
even+even≢odd (2+ m)  n      (2+₁ m+n) = even+even≢odd m n m+n

-- 4.2.
--
-- even+even≢even : {m n : ℕ} → 2×ℕ m → 2×ℕ n → ¬ 2×ℕ (m + n)
-- even+even≢even zero zero ()
-- ^
-- rejected with the following message:
--
--   2×ℕ zero should be empty, but the following constructor patterns
--   are valid:
--     zero
--   when checking that the clause even+even≢even zero zero () has type
--   {m n : ℕ} → 2×ℕ m → 2×ℕ n → ¬ 2×ℕ (m + n)
--
