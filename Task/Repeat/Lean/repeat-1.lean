def repeat : ℕ → (ℕ → string) → string
  | 0 f       := "done"
  | (n + 1) f :=  (f n) ++ (repeat n f)


#eval repeat 5 $ λ b : ℕ , "me "
