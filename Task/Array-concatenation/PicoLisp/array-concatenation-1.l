: (setq  A (1 2 3)  B '(a b c))
-> (a b c)
: (conc A B)                        # Concatenate lists in 'A' and 'B'
-> (1 2 3 a b c)
: A
-> (1 2 3 a b c)                    # Side effect: List in 'A' is modified!
