#!/usr/bin/env BQN
# Takes the size of grid (1 side) and the size of the starting pile as command line arguments
size‿pile←•BQN¨ 2↑•args
_Fp←{𝔽∘⊢⍟≢⟜𝔽_𝕣∘⊢⍟≢⟜𝔽𝕩} # Fixed point function
Sand←{p←𝕩≥4 ⋄ (𝕩+¯4×p)++´⟨«,»,«˘,»˘⟩{𝕎𝕩}¨<p}_Fp # Calculates given sand grid until it stops changing

last←Sand pile˙⌾((⋈˜⌊size÷2)⊸⊑) size‿size⥊0 # Calculate the last state of the sand grid

# PPM output, code taken from https://rosettacode.org/wiki/Bitmap/Write_a_PPM_file#BQN
header_ppm←"P6"∾(@+10)∾(•Repr size)∾" "∾(•Repr size)∾(@+10)∾"255"∾@+10
colors←4⊸↑⌾⌽255×=⌜˜↕3 # Black, Red, Green, Blue
image_ppm←@+⥊colors⊏˜4|last
"sandpile.ppm" •file.Bytes header_ppm∾image_ppm
