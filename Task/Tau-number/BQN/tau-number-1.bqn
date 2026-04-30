# 1 if number is a tau number
Is_tau ← 0=(+´0=(1+↕)⊸|)⊸|

# recursively find 100 tau numbers
0 {100≤≠𝕩 ? 𝕩 ;
   Is_tau 𝕨 ? (𝕨+1)𝕊(𝕩∾𝕨) ;
   (𝕨+1)𝕊𝕩
} ⟨⟩
