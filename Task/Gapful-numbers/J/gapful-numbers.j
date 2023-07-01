gapful =: 0 = (|~ ({.,{:)&.(10&#.inv))

task =: 100&$: :(dyad define)  NB. MINIMUM task TALLY
 gn =. y {. (#~ gapful&>) x + i. y * 25
 assert 0 ~: {: gn
 'The first ' , (": y) , ' gapful numbers exceeding ' , (":<:x) , ' are ' , (":gn)
)
