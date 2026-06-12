converge: function[
    num [number!]
][
    i: 0
    until [
        ++ i
        prev: num
        num:  num + 3 * 0.86
        prev = num
    ]
    reduce [num i]
]

while [integer? num: try [to integer! ask "Number: "]][
    res: converge num
    print ["For value" num "->" res/1 "after" res/2 "iterations."]
]
