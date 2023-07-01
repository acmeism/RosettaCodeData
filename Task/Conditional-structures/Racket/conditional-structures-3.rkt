(printf "x is ~a\n"
        (cond [(< x 1)     "tiny"]
              [(< x 10)    "small"]
              [(< x 100)   "medium"]
              [(< x 10000) "big"]
              [(< x 100000000) "huge"]
              [else "gigantic"]))
