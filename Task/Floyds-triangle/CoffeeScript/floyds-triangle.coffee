triangle = (array) -> for n in array
    console.log "#{n} rows:"
    printMe = 1
    printed = 0
    row = 1
    to_print = ""
    while row <= n
        cols = Math.ceil(Math.log10(n * (n - 1) / 2 + printed + 2.0))
        p = ("" + printMe).length
        while p++ <= cols
            to_print += ' '
        to_print += printMe + ' '
        if ++printed == row
            console.log to_print
            to_print = ""
            row++
            printed = 0
        printMe++

triangle [5, 14]
