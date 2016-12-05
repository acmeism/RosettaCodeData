import: math

[
   676.5203681218851,  -1259.1392167224028, 771.32342877765313,
  -176.61502916214059, 12.507343278686905, -0.13857109526572012,
   9.9843695780195716e-6, 1.5056327351493116e-7
] const: Gamma.Lanczos

: gamma(z)
| i t |
   z 0.5 < ifTrue: [ Pi dup z * sin 1.0 z - gamma * / return ]
   z 1.0 - ->z
   0.99999999999980993 Gamma.Lanczos size loop: i [ i Gamma.Lanczos at z i + / + ]
   z Gamma.Lanczos size + 0.5 - ->t
   2 Pi * sqrt *
   t z 0.5 + powf *
   t neg exp * ;
