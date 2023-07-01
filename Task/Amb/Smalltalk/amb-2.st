result :=
  Amb try:#('the' 'that' 'a')                in:[:w1 |
    Amb try:#('frog' 'elephant' 'thing')     in:[:w2 |
      w2 first = w1 last ifTrue:[
        Amb try:#('walked' 'traded' 'grows') in:[:w3 |
          w3 first = w2 last ifTrue:[
            Amb try:#('slowly' 'quickly')    in:[:w4 |
              Transcript showCR: e'trying {{w1 . w2 . w3 . w4}}'. "debug trace only"
              w4 first = w3 last ifTrue:[
                {w1 . w2 . w3 . w4} ]]]]]]].
Transcript showCR: e'found solution: {result}'
