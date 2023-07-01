function Mean(lst)
    if empty(a:lst)
        throw "Empty"
    endif
    let sum = 0.0
    for i in a:lst
        let sum += i
    endfor
    return sum / len(a:lst)
endfunction
