NOT
¬F = T
¬? = ?
¬T = F

NAND         AND          OR           NOR          IMPLIES      IFF           XOR
F ⊼ F = T    F ∧ F = F    F ∨ F = F    F ⊽ F = T    F → F = T    F ↔ F = T    F ⊻ F = F
F ⊼ ? = T    F ∧ ? = F    F ∨ ? = ?    F ⊽ ? = ?    F → ? = T    F ↔ ? = ?    F ⊻ ? = ?
F ⊼ T = T    F ∧ T = F    F ∨ T = T    F ⊽ T = F    F → T = T    F ↔ T = F    F ⊻ T = T
? ⊼ F = T    ? ∧ F = F    ? ∨ F = ?    ? ⊽ F = ?    ? → F = ?    ? ↔ F = ?    ? ⊻ F = ?
? ⊼ ? = ?    ? ∧ ? = ?    ? ∨ ? = ?    ? ⊽ ? = ?    ? → ? = ?    ? ↔ ? = ?    ? ⊻ ? = ?
? ⊼ T = ?    ? ∧ T = ?    ? ∨ T = T    ? ⊽ T = F    ? → T = T    ? ↔ T = ?    ? ⊻ T = ?
T ⊼ F = T    T ∧ F = F    T ∨ F = T    T ⊽ F = F    T → F = F    T ↔ F = F    T ⊻ F = T
T ⊼ ? = ?    T ∧ ? = ?    T ∨ ? = T    T ⊽ ? = F    T → ? = ?    T ↔ ? = ?    T ⊻ ? = ?
T ⊼ T = F    T ∧ T = T    T ∨ T = T    T ⊽ T = F    T → T = T    T ↔ T = T    T ⊻ T = F
