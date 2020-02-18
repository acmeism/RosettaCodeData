(define permute-helper
_ [] -> []
Done [X|Rest] -> (append (prepend-all X (permute (append Done Rest))) (permute-helper (append Done [X]) Rest))
)
