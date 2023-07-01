str ← "one^|uno||three^^^^|four^^^|^cuatro|"
Split ← ((⊢-˜+`×¬)∘=⊔⊢)
SplitE ← {
  esc ← <`'^'=𝕩
  rem ← »esc
  spl ← (¬rem)∧'|'=𝕩
  𝕩⊔˜(⊢-(esc∨spl)×1⊸+)+`spl
}

•Show SplitE str
