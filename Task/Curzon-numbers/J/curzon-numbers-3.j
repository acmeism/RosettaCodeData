generateCurzons =: {{
  found =. i. 0x
  current =. 0x
  while. 1000 > # found do.
  if. y isCurzon current do. found =. found , current end.
  current =. >: current
  end.
  y ; (5 10 $ found) ; {: found
}}

('Base';'First 50';'1000th') , generateCurzons"0 +:>:i.5
