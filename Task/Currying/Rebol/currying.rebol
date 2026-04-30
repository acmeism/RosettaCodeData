;; Based on the Red language solution bellow.
make-curry: func[
    "Define a custome simple currying function"
    'fn [word!]
    x
][
    do compose/deep [
        func [
            (reform ["currying function:" form fn x "y"])
            y
        ][  do compose [(get fn) (x) y]]
    ]
]
add2: make-curry add 2
add3: make-curry add 3
print add2 7
print add3 7
print "^/Help output:"
help add3
