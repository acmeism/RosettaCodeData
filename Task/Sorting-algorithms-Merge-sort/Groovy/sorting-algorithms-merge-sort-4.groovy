split = { list, left=[], right=[] ->
    if(list.size() <2) [list+left, right]
    else split.trampoline(list.tail().tail(), [list.head()]+left,[list.tail().head()]+right)
}.trampoline()
