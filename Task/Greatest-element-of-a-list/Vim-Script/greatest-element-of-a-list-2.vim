function! Max(list, ...)
    " {list}	list of strings
    " {a:1}	'i': ignore case, 'I': match case, otherwise use 'ignorecase' option
    if empty(a:list)
	return 0
    endif
    let gt_op = a:0>=1 ? get({'i': '>?', 'I': '>#'}, a:1, '>') : '>'
    let cmp_expr = printf('a:list[idx] %s maxval', gt_op)
    let maxval = a:list[0]
    let len = len(a:list)
    let idx = 1
    while idx < len
	if eval(cmp_expr)
	    let maxval = a:list[idx]
	endif
	let idx += 1
    endwhile
    return maxval
endfunction
