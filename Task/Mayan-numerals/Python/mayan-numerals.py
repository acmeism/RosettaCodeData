'''Mayan numerals'''

from functools import (reduce)


# -------------------- MAYAN NUMERALS --------------------

# mayanNumerals :: Int -> [[String]]
def mayanNumerals(n):
    '''Rows of Mayan digit cells,
       representing the integer n.
    '''
    return showIntAtBase(20)(
        mayanDigit
    )(n)([])


# mayanDigit :: Int -> [String]
def mayanDigit(n):
    '''List of strings representing a Mayan digit.'''
    if 0 < n:
        r = n % 5
        return [
            (['●' * r] if 0 < r else []) +
            (['━━'] * (n // 5))
        ]
    else:
        return ['Θ']


# mayanFramed :: Int -> String
def mayanFramed(n):
    '''Mayan integer in the form of a
       Wiki table source string.
    '''
    return 'Mayan ' + str(n) + ':\n\n' + (
        wikiTable({
            'class': 'wikitable',
            'style': cssFromDict({
                'text-align': 'center',
                'background-color': '#F0EDDE',
                'color': '#605B4B',
                'border': '2px solid silver'
            }),
            'colwidth': '3em',
            'cell': 'vertical-align: bottom;'
        })([[
            '<br>'.join(col) for col in mayanNumerals(n)
        ]])
    )


# ------------------------- TEST -------------------------

# main :: IO ()
def main():
    '''Mayan numeral representations of various integers'''
    print(
        main.__doc__ + ':\n\n' +
        '\n'.join(mayanFramed(n) for n in [
            4005, 8017, 326205, 886205, 1081439556,
            1000000, 1000000000
        ])
    )


# ------------------------ BOXES -------------------------

# wikiTable :: Dict -> [[a]] -> String
def wikiTable(opts):
    '''Source text for wiki-table display of rows of cells,
       using CSS key-value pairs in the opts dictionary.
    '''
    def colWidth():
        return 'width:' + opts['colwidth'] + '; ' if (
            'colwidth' in opts
        ) else ''

    def cellStyle():
        return opts['cell'] if 'cell' in opts else ''

    return lambda rows: '{| ' + reduce(
        lambda a, k: (
            a + k + '="' + opts[k] + '" ' if (
                k in opts
            ) else a
        ),
        ['class', 'style'],
        ''
    ) + '\n' + '\n|-\n'.join(
        '\n'.join(
            ('|' if (
                0 != i and ('cell' not in opts)
            ) else (
                '|style="' + colWidth() + cellStyle() + '"|'
            )) + (
                str(x) or ' '
            ) for x in row
        ) for i, row in enumerate(rows)
    ) + '\n|}\n\n'


# ----------------------- GENERIC ------------------------

# cssFromDict :: Dict -> String
def cssFromDict(dct):
    '''CSS string from a dictinary of key-value pairs'''
    return reduce(
        lambda a, k: a + k + ':' + dct[k] + '; ',
        dct.keys(),
        ''
    )


# showIntAtBase :: Int -> (Int -> String)
# -> Int -> String -> String
def showIntAtBase(base):
    '''String representation of an integer in a given base,
       using a supplied function for the string
       representation of digits.
    '''
    def wrap(toChr, n, rs):
        def go(nd, r):
            n, d = nd
            r_ = toChr(d) + r
            return go(divmod(n, base), r_) if 0 != n else r_
        return 'unsupported base' if 1 >= base else (
            'negative number' if 0 > n else (
                go(divmod(n, base), rs))
        )
    return lambda toChr: lambda n: lambda rs: (
        wrap(toChr, n, rs)
    )


# MAIN ---
if __name__ == '__main__':
    main()
