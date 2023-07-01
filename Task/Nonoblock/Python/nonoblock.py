def nonoblocks(blocks, cells):
    if not blocks or blocks[0] == 0:
        yield [(0, 0)]
    else:
        assert sum(blocks) + len(blocks)-1 <= cells, \
            'Those blocks will not fit in those cells'
        blength, brest = blocks[0], blocks[1:]      # Deal with the first block of length
        minspace4rest = sum(1+b for b in brest)     # The other blocks need space
        # Slide the start position from left to max RH index allowing for other blocks.
        for bpos in range(0, cells - minspace4rest - blength + 1):
            if not brest:
                # No other blocks to the right so just yield this one.
                yield [(bpos, blength)]
            else:
                # More blocks to the right so create a *sub-problem* of placing
                # the brest blocks in the cells one space to the right of the RHS of
                # this block.
                offset = bpos + blength +1
                nonoargs = (brest, cells - offset)  # Pre-compute arguments to nonoargs
                # recursive call to nonoblocks yields multiple sub-positions
                for subpos in nonoblocks(*nonoargs):
                    # Remove the offset from sub block positions
                    rest = [(offset + bp, bl) for bp, bl in subpos]
                    # Yield this block plus sub blocks positions
                    vec = [(bpos, blength)] + rest
                    yield vec

def pblock(vec, cells):
    'Prettyprints each run of blocks with a different letter A.. for each block of filled cells'
    vector = ['_'] * cells
    for ch, (bp, bl) in enumerate(vec, ord('A')):
        for i in range(bp, bp + bl):
            vector[i] = chr(ch) if vector[i] == '_' else'?'
    return '|' + '|'.join(vector) + '|'


if __name__ == '__main__':
    for blocks, cells in (
            ([2, 1], 5),
            ([], 5),
            ([8], 10),
            ([2, 3, 2, 3], 15),
           # ([4, 3], 10),
           # ([2, 1], 5),
           # ([3, 1], 10),
            ([2, 3], 5),
            ):
        print('\nConfiguration:\n    %s # %i cells and %r blocks' % (pblock([], cells), cells, blocks))
        print('  Possibilities:')
        for i, vector in enumerate(nonoblocks(blocks, cells)):
            print('   ', pblock(vector, cells))
        print('  A total of %i Possible configurations.' % (i+1))
