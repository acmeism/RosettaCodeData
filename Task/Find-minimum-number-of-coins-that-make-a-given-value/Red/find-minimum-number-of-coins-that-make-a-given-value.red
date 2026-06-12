Red[]

value: 988
foreach denomination [200 100 50 20 10 5 2 1][
    quantity: to-integer value / denomination
    unless 0 = quantity [print [quantity "*" denomination]]
    value: value % denomination
]
