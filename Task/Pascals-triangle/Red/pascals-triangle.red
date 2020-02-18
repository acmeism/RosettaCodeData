Red[]
pascal-triangle: function [
    n [ integer! ] "number of rows"
 ][
    row: make vector! [ 1 ]
    loop n [
        print row
        left: copy row
        right: copy row
        insert left 0
        append right 0
        row: left + right
    ]
]
