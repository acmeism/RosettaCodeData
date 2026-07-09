Rebol [
    title: "Rosetta code: Nested function"
    file:  %Nested_function.r3
    url:   https://rosettacode.org/wiki/Nested_function
]

make-list: function [separator [string!]] [
    counter: 1
    make-item: func [item [string!]] [
        ajoin [++ counter separator item newline]
    ]
    ajoin [
        make-item "first"
        make-item "second"
        make-item "third"
    ]
]

print make-list ". "
