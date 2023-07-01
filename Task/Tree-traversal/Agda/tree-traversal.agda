open import Data.List using (List; _?_; []; concat)
open import Data.Nat using (N; suc; zero)
open import Level using (Level)
open import Relation.Binary.PropositionalEquality using (_=_; refl)

data Tree {a} (A : Set a) : Set a where
  leaf : Tree A
  node : A ? Tree A ? Tree A ? Tree A

variable
  a : Level
  A : Set a

preorder : Tree A ? List A
preorder tr = go tr []
  where
  go : Tree A ? List A ? List A
  go leaf           ys = ys
  go (node x ls rs) ys = x ? go ls (go rs ys)

inorder : Tree A ? List A
inorder tr = go tr []
  where
  go : Tree A ? List A ? List A
  go leaf           ys = ys
  go (node x ls rs) ys = go ls (x ? go rs ys)

postorder : Tree A ? List A
postorder tr = go tr []
  where
  go : Tree A ? List A ? List A
  go leaf           ys = ys
  go (node x ls rs) ys = go ls (go rs (x ? ys))

level-order : Tree A ? List A
level-order tr = concat (go tr [])
  where
  go : Tree A ? List (List A) ? List (List A)
  go leaf qs                 = qs
  go (node x ls rs) []       = (x ? []) ? go ls (go rs [])
  go (node x ls rs) (q ? qs) = (x ? q ) ? go ls (go rs qs)

example-tree : Tree N
example-tree =
  node 1
    (node 2
      (node 4
        (node 7
          leaf
          leaf)
        leaf)
      (node 5
        leaf
        leaf))
    (node 3
      (node 6
        (node 8
          leaf
          leaf)
        (node 9
          leaf
          leaf))
      leaf)

_ : preorder example-tree = 1 ? 2 ? 4 ? 7 ? 5 ? 3 ? 6 ? 8 ? 9 ? []
_ = refl

_ : inorder example-tree = 7 ? 4 ? 2 ? 5 ? 1 ? 8 ? 6 ? 9 ? 3 ? []
_ = refl

_ : postorder example-tree = 7 ? 4 ? 5 ? 2 ? 8 ? 9 ? 6 ? 3 ? 1 ? []
_ = refl

_ : level-order example-tree = 1 ? 2 ? 3 ? 4 ? 5 ? 6 ? 7 ? 8 ? 9 ? []
_ = refl
