compose : ∀ {a b c} {A : Set a} {B : Set b} {C : Set c}
        → (B → C)
        → (A → B)
        → A → C
compose f g x = f (g x)
