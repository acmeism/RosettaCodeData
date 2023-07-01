header_ppm ← "P6
800 800
255
"
image_ppm ← @ + ⥊ > {256|𝕨‿𝕩‿(𝕨×𝕩)}⌜˜ ↕800
"first_bqn.ppm" •file.Bytes header_ppm ∾ image_ppm
