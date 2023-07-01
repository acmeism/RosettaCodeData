  'InitCauseway' 'View' ⎕CY 'sharpplot'
  InitCauseway ⍬   ⍝ initialise current namespace
  sp←⎕NEW Causeway.SharpPlot
  sp.DrawPolarChart {⍵(360|⍵)}⌽⍳720
      View sp
