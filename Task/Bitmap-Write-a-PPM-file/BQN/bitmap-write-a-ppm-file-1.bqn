header_ppm ← "P6
4 8
255
"
red ← 255‿0‿0  # a 3-element 1D list
grn ← 0‿255‿0
ble ← 0‿0‿255
blk ← 0‿0‿0
gry ← 128‿128‿128
wht ← 255‿255‿255
all ← ∾red‿grn‿ble‿blk‿gry‿wht  # join "colors" to 1D list
image_ppm ← 8‿4‿3 ⥊ all  # reshape "all" to 8 rows by 4 cols by 3, "all" gets reused as needed to fill
image_ppm ↩ @ + ⥊ image_ppm  # deshape, convert to chars (uint8_t)
bytes_ppm ← header_ppm ∾ image_ppm
"small.ppm" •file.Bytes bytes_ppm
