digch=: a.{~;48 97(+i.)&.>10 26
brep=: (digch {~ #.inv)&.>

penholod=: {{
  F=: >.%:y#.D=:}.i.y
  C=: <.%:y#.}:i.-y
  ok=: (D */@e. y #.inv ])"0
  (#~ok) *:F+i.1+C-F
}}

task=: {{
  sq=. penholod y
  hd=. ,:(#sq),&":' penholodigital squares in base ',":y
  hd,(*#sq)#names (y brep sq),each '=',each(y brep %:sq),each<'²'
}}

stretch=: {{
  sq=. penholod y
  hd=. ,:(#sq),&":' penholodigital squares in base ',":y
  hd,(*#sq)#names ({.,'...';{:) (y brep sq),each '=',each(y brep %:sq),each<'²'
}}
