data Bool : Set where
  true : Bool
  false : Bool

if_then_else : ∀ {l} {A : Set l} -> Bool -> A -> A -> A
if true then t else e = t
if false then t else e = e

if2_,_then_else1_else2_else_ : ∀ {l} {A : Set l} -> (b1 b2 : Bool) -> (t e1 e2 e : A) -> A
if2 true , true then t else1 e1 else2 e2 else e = t
if2 true , false then t else1 e1 else2 e2 else e = e1
if2 false , true then t else1 e1 else2 e2 else e = e2
if2 false , false then t else1 e1 else2 e2 else e = e

example : Bool
example = if2 true , false then true else1 false else2 true else false
