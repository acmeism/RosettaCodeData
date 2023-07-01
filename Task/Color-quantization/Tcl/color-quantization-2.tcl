set src [image create photo -file quantum_frog.png]
set dst [colorQuant $src 16]
# Save as GIF now that quantization is done, then exit explicitly (no GUI desired)
$dst write quantum_frog_compressed.gif
exit
