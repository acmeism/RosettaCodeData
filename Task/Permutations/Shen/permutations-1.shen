(define permute
[] -> []
[X] -> [[X]]
X -> (permute-helper [] X))

(define permute-helper
_ [] -> []
Done [X|Rest] -> (append (prepend-all X (permute (append Done Rest))) (permute-helper [X|Done] Rest))
)

(define prepend-all
_ [] -> []
X [Next|Rest] -> [[X|Next]|(prepend-all X Rest)]
)

(set *maximum-print-sequence-size* 50)

(permute [a b c d])
