ToUpper ← -⟜(32×1="a{"⊸⍋)
Split ← ((⊢-˜+`×¬)∘=⊔⊢)
replace ← ⟨
  "AEIOUYHW"
  "BFPV"
  "CGJKQSXZ"
  "DT"
  "L"
  "MN"
  "R"
⟩

Soundex ← ⊑∾{'0'+»⟜0‿0‿0⊑¨0⊸≠⊸/(0≠⊑)⊸↓⊑¨(¯1+·+`1»≠⟜«)⊸⊔∾/¨<˘⍉>replace∊˜¨<ToUpper 𝕩}

names ← ' ' Split "Lloyd Woolcock Donnell Baragwanath Williams Ashcroft Euler Ellery Gauss Ghosh Hilbert Heilbronn Knuth Kant Ladd Lukasiewicz Lissajous"
vals ← ' ' Split "L300 W422 D540 B625 W452 A226 E460 E460 G200 G200 H416 H416 K530 K530 L300 L222 L222"

•Show >(⊢ ⋈ Soundex)¨names
•Show vals≡Soundex¨names
