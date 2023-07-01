def chain_insert(lst, at, item):
    while lst is not None:
        if lst[0] == at:
            lst[1] = [item, lst[1]]
            return
        else:
            lst = lst[1]
    raise ValueError(str(at) + " not found")

chain = ['A', ['B', None]]
chain_insert(chain, 'A', 'C')
print chain
