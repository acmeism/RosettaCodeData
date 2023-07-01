Amb
   tryAll:#(
            ('the' 'that' 'a')
            ('frog' 'elephant' 'thing')
            ('walked' 'traded' 'grows')
            ('slowly' 'quickly')
   ) in:[:w1 :w2 :w3 :w4 |
       (w2 first = w1 last
         and:[ w3 first = w2 last
         and:[ w4 first = w3 last
       ]]) ifTrue:[
           {w1 . w2 . w3 . w4} ]]
