NOT
¬F = F
¬U = U
¬T = T

NAND         AND          OR           NOR          IMPLIES       IFF           XOR
F ⊼ F = T    F ∧ F = F    F ∨ F = F    F ⊽ F = T    F ⇒ F = T    F ⇔ F = T    F ⊻ F = F
F ⊼ U = T    F ∧ U = F    F ∨ U = U    F ⊽ U = U    F ⇒ U = T    F ⇔ U = U    F ⊻ U = U
F ⊼ T = T    F ∧ T = F    F ∨ T = T    F ⊽ T = F    F ⇒ T = T    F ⇔ T = F    F ⊻ T = T
U ⊼ F = T    U ∧ F = F    U ∨ F = U    U ⊽ F = U    U ⇒ F = U    U ⇔ F = U    U ⊻ F = U
U ⊼ U = U    U ∧ U = U    U ∨ U = U    U ⊽ U = U    U ⇒ U = U    U ⇔ U = U    U ⊻ U = U
U ⊼ T = U    U ∧ T = U    U ∨ T = T    U ⊽ T = F    U ⇒ T = T    U ⇔ T = U    U ⊻ T = U
T ⊼ F = T    T ∧ F = F    T ∨ F = T    T ⊽ F = F    T ⇒ F = F    T ⇔ F = F    T ⊻ F = T
T ⊼ U = U    T ∧ U = U    T ∨ U = T    T ⊽ U = F    T ⇒ U = U    T ⇔ U = U    T ⊻ U = U
T ⊼ T = F    T ∧ T = T    T ∨ T = T    T ⊽ T = F    T ⇒ T = T    T ⇔ T = T    T ⊻ T = F
