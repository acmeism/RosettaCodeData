NB. matrix characteristic polynomial
mcp=: {{ ;pdf/ .ppr y,each -=i.#y }}
pdf=: -/@,:L:0      NB. polynomial difference
ppr=: +//.@(*/)L:0  NB. polynomial product
proots=: 1 {:: p.   NB. polynomial roots

task=: {{
  poly=. mcp y
  roots=. proots poly
  errors=. poly p."1 0 roots
  lines=. (,:'matrix: '),&.|:&": y
  lp=. 'coefficients: ',":poly
  lr=. 'roots:  ',":roots
  le=. 'errors: ',":errors
  lines,lp,lr,:le
}}
