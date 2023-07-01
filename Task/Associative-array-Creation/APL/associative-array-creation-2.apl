      ⍝ Assign some names
      X.this←'that'
      X.foo←88

      ⍝  Access the names
      X.this
that

      ⍝  ..or access via 'array index' syntax
      X['this']
that

      ⍝  Or do it the array way
      X.(foo)
88

      ⍝ GNU APL does not support multiple assoc. array indices however
      X.(foo this)
VALUE ERROR
      X.(foo this)
             ^

      (sales.prices sales.quantities) ← (100 98.4 103.4 110.16) (10 12 8 10)
      sales.revenue ← sales.prices +.× sales.quantities
      sales.revenue
4109.6
