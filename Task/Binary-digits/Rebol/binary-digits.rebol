foreach number [5 50 9000] [
    ;; any returns first not false value, used to cut leading zeroes
    binstr: copy any [find enbase/flat to binary! number 2 #"1" #"0"]
    print reduce [ pad number -5 binstr ]
]
