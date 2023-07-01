" Create a two-dimensional array with r rows and c columns.
" The optional third argument specifies the initial value
" (default is 0).
function MakeArray(r, c, ...)
    if a:0
        let init = a:1
    else
        let init = 0
    endif

    let temp = []
    for c in range(a:c)
        call add(temp, init)
    endfor

    let array = []
    for r in range(a:r)
        call add(array, temp[:])
    endfor
    return array
endfunction

let rows = input("Enter number of rows: ")
let cols = input("Enter number of columns: ")
echo "\n"
let array = MakeArray(rows, cols)
let array[rows - 1][cols - 1] = rows * cols
echo array[rows - 1][cols - 1]
unlet array
