'''Variously aligned columns
   from delimited text.
'''

from functools import reduce
from itertools import repeat


# TEST ----------------------------------------------------
# main :: IO ()
def main():
    '''Test of three alignments.'''

    txt = '''Given$a$text$file$of$many$lines,$where$fields$within$a$line$
are$delineated$by$a$single$'dollar'$character,$write$a$program
that$aligns$each$column$of$fields$by$ensuring$that$words$in$each$
column$are$separated$by$at$least$one$space.
Further,$allow$for$each$word$in$a$column$to$be$either$left$
justified,$right$justified,$or$center$justified$within$its$column.'''

    rows = [x.split('$') for x in txt.splitlines()]
    table = paddedRows(max(map(len, rows)))('')(rows)

    print('\n\n'.join(map(
        alignedTable(table)('  '),
        [-1, 0, 1]  # Left, Center, Right
    )))


# alignedTable :: [[String]] -> Alignment -> String -> String
def alignedTable(rows):
    '''Tabulation of rows of cells, with cell alignment
       specified by:
           eAlign -1 = left
           eAlign  0 = center
           eAlign  1 = right
       and separator between columns
       supplied by the `sep` argument.
    '''
    def go(sep, eAlign):
        lcr = ['ljust', 'center', 'rjust'][1 + eAlign]

        # nextAlignedCol :: [[String]] -> [String] -> [[String]]
        def nextAlignedCol(cols, col):
            w = max(len(cell) for cell in col)
            return cols + [
                [getattr(s, lcr)(w, ' ') for s in col]
            ]

        return '\n'.join([
            sep.join(cells) for cells in
            zip(*reduce(nextAlignedCol, zip(*rows), []))
        ])
    return lambda sep: lambda eAlign: go(sep, eAlign)


# GENERIC -------------------------------------------------

# paddedRows :: Int -> a -> [[a]] -> [[a]]
def paddedRows(n):
    '''A list of rows of even length,
       in which each may be padded (but
       not truncated) to length n with
       appended copies of value v.'''
    def go(v, xs):
        def pad(x):
            d = n - len(x)
            return (x + list(repeat(v, d))) if 0 < d else x
        return [pad(row) for row in xs]
    return lambda v: lambda xs: go(v, xs) if xs else []


# MAIN ---
if __name__ == '__main__':
    main()
