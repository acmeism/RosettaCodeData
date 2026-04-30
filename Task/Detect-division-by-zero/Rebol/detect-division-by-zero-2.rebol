div-check: func [
    "Attempt to divide two numbers, report result or errors as needed."
    x y
    /local result
] [
    print either error? result: try [x / y][
        ["Caught" result/type "error:" result/id]
    ][  [x "/" y "=" result]]
    result
]

div-check 12 2       ; An ordinary calculation.
div-check 6 0        ; This will detect divide by zero.
div-check "7" 0.0001 ; Other errors can be caught as well.
