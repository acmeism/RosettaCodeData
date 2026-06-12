{-# LANGUAGE TypeOperators, TypeFamilies, GADTs #-}

module PeanoArithmetic where

-- 1.1. Natural numbers.

data Z = Z
data S m = S m

-- 2.1. Addition.

infixl 6 :+
type family x :+ y
type instance Z :+ n = n
type instance S m :+ n = S (m :+ n)

-- 1.2. Even natural numbers.

data En :: * -> * where
  Ez :: En Z
  Es :: En m -> En (S (S m))

-- 1.3. Odd natural numbers.

data On :: * -> * where
  Oo :: On (S Z)
  Os :: On m -> On (S (S m))

-- 3.1. Sum of any two even numbers is even.

sum_of_even_is_even :: En m -> En n -> En (m :+ n)
sum_of_even_is_even Ez n = n
sum_of_even_is_even (Es m) n = Es $ sum_of_even_is_even m n

-- The identity type for natural numbers.

infix 4 :=
data (:=) m :: * -> * where
  Refl :: m := m

sym :: m := n -> n := m
sym Refl = Refl

trans :: m := n -> n := p -> m := p
trans Refl np = np

cong :: m := n -> S m := S n
cong Refl = Refl

-- 3.2. Associativity of addition (via propositional equality).

class AssocAdd m where
  proof :: m -> n -> p -> (m :+ n) :+ p := m :+ (n :+ p)

instance AssocAdd Z where
  proof Z _ _ = Refl

instance AssocAdd m => AssocAdd (S m) where
  proof (S m) n p = cong $ proof m n p

-- Induction, associativity of addition by induction, equational reasoning and
-- commutativity of addition is too tricky.

-- 3.4. Bad proof.

sum_of_even_is_odd :: En m -> En n -> On (m :+ n)
-- ^
-- Сan not be written totally:
--
sum_of_even_is_odd Ez Ez = undefined
-- ^
-- then, in GHCi:
--
--   *PeanoArithmetic> :t sum_of_even_is_odd Ez Ez
--   sum_of_even_is_odd Ez Ez :: On (Z :+ Z)
--   *PeanoArithmetic> :t undefined :: On (Z :+ Z)
--   undefined :: On (Z :+ Z) :: On Z
--   *PeanoArithmetic> :t sum_of_even_is_odd Ez Ez :: On Z
--   sum_of_even_is_odd Ez Ez :: On Z :: On Z
--   *PeanoArithmetic> :t Oo
--   Oo :: On (S Z)
--   *PeanoArithmetic> :t Os Oo
--   Os Oo :: On (S (S (S Z)))
--   *PeanoArithmetic> :t Os (Os Oo)
--   Os (Os Oo) :: On (S (S (S (S (S Z)))))
--
-- so that sum_of_even_is_odd Ez Ez :: On Z, but On Z is empty, it is impossible
-- to write such a proof.
--

-- Uninhabited type.

data Bot

-- Negation.

type Not a = a -> Bot

-- 4.1. Disproof.

sum_of_even_is_not_odd :: En m -> En n -> Not (On (m :+ n))
sum_of_even_is_not_odd Ez (Es n) (Os mn) = sum_of_even_is_not_odd Ez n mn
sum_of_even_is_not_odd (Es m) n (Os mn) = sum_of_even_is_not_odd m n mn
sum_of_even_is_not_odd Ez Ez _ =
  error "impossible happened in sum_of_even_is_not_odd!"
-- ^
-- partial, however, we know that Ez :: En Z, Z + Z = Z and On Z is
-- uninhabited, so that this clause is unreachable.
--
-- Also, GHC complains:
--
--   Warning: Pattern match(es) are non-exhaustive
--           In an equation for `sum_of_even_is_not_odd':
--               Patterns not matched:
--                   Ez (Es _) Oo
--                   (Es _) _ Oo
--
-- and can't find that this clauses is unreachable too, since this isn't type check:
--
--   sum_of_even_is_not_odd Ez (Es _) Oo = undefined
--   sum_of_even_is_not_odd (Es _) _ Oo = undefined
--

-- 4.2. Bad disproof.

sum_of_even_is_not_even :: En m -> En n -> Not (En (m :+ n))
--
-- Starting from a partial definition:
--
sum_of_even_is_not_even Ez Ez _ = undefined
--
-- we can show that it can not be rewritten totally:
--
--   *PeanoArithmetic> :t sum_of_even_is_not_even Ez Ez
--   sum_of_even_is_not_even Ez Ez :: Not (En (Z :+ Z))
--   *PeanoArithmetic> :t sum_of_even_is_not_even Ez Ez :: Not (En Z)
--   sum_of_even_is_not_even Ez Ez :: Not (En Z) :: Not (En Z)
--   *PeanoArithmetic> :t sum_of_even_is_not_even Ez Ez :: En Z -> Bot
--   sum_of_even_is_not_even Ez Ez :: En Z -> Bot :: En Z -> Bot
--   *PeanoArithmetic> :t Ez
--   Ez :: En Z
--   *PeanoArithmetic> :t (sum_of_even_is_not_even Ez Ez :: En Z -> Bot) Ez
--   (sum_of_even_is_not_even Ez Ez :: En Z -> Bot) Ez :: Bot
--
-- since we have a "citizen" of an uninhabited type here (contradiction!).
--
