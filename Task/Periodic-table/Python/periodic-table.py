def perta(atomic) -> (int, int):

    NOBLES = 2, 10, 18, 36, 54, 86, 118
    INTERTWINED = 0, 0, 0, 0, 0, 57, 89
    INTERTWINING_SIZE = 14
    LINE_WIDTH = 18

    prev_noble = 0
    for row, noble in enumerate(NOBLES):
        if atomic <= noble:  # we are at the good row. We now need to determine the column
            nb_elem = noble - prev_noble  # number of elements on that row
            rank =  atomic - prev_noble  # rank of the input element among elements
            if INTERTWINED[row] and INTERTWINED[row] <= atomic <= INTERTWINED[row] + INTERTWINING_SIZE:  # lantanides or actinides
                row += 2
                col = rank + 1
            else:  # not a lantanide nor actinide
                # handle empty spaces between 1-2, 4-5 and 12-13.
                nb_empty = LINE_WIDTH - nb_elem  # spaces count as columns
                inside_left_element_rank = 2 if noble > 2 else 1
                col = rank + (nb_empty if rank > inside_left_element_rank else 0)
            break
        prev_noble = noble
    return row+1, col



# small test suite

TESTS = {
    1: (1, 1),
    2: (1, 18),
    29: (4,11),
    42: (5, 6),
    58: (8, 5),
    59: (8, 6),
    57: (8, 4),
    71: (8, 18),
    72: (6, 4),
    89: (9, 4),
    90: (9, 5),
    103: (9, 18),
}

for input, out in TESTS.items():
    found = perta(input)
    print('TEST:{:3d} -> '.format(input) + str(found) + (f' ; ERROR: expected {out}' if found != out else ''))
