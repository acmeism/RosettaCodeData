'''Spiral Matrix'''


# spiral :: Int -> [[Int]]
def spiral(n):
    '''The rows of a spiral matrix of order N.
    '''
    def go(rows, cols, x):
        return [range(x, x + cols)] + [
            reversed(x) for x
            in zip(*go(cols, rows - 1, x + cols))
        ] if 0 < rows else [[]]
    return go(n, n, 0)


# ------------------------- TEST -------------------------
# main :: IO ()
def main():
    '''Spiral matrix of order 5, in wiki table markup.
    '''
    print(
        wikiTable(spiral(5))
    )


# ---------------------- FORMATTING ----------------------

# wikiTable :: [[a]] -> String
def wikiTable(rows):
    '''Wiki markup for a no-frills tabulation of rows.'''
    return '{| class="wikitable" style="' + (
        'width:12em;height:12em;table-layout:fixed;"|-\n'
    ) + '\n|-\n'.join(
        '| ' + ' || '.join(
            str(cell) for cell in row
        )
        for row in rows
    ) + '\n|}'


# MAIN ---
if __name__ == '__main__':
    main()
