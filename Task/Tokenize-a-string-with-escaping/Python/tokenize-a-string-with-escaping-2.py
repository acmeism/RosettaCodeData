'''Tokenize a string with escaping'''

from functools import reduce


# tokenize :: Char -> Char -> String -> [String]
def tokenize(delim):
    '''A list of the tokens in a string, given
       a delimiting char and an escape char.
    '''
    def go(esc, s):
        def chop(a, x):
            tkn, xs, escaped = a
            literal = not escaped
            isEsc = literal and (esc == x)
            return ([], [tkn] + xs, isEsc) if (
                literal and (delim == x)
            ) else (tkn if isEsc else [x] + tkn, xs, isEsc)

        tkn, xs, _ = reduce(chop, list(s), ([], [], False))

        return list(reversed(
            [''.join(reversed(x)) for x in [tkn] + xs]
        ))
    return lambda esc: lambda s: go(esc, s)


# --------------------------TEST---------------------------
# main :: IO ()
def main():
    '''Test'''

    print(
        tokenize('|')('^')(
            "one^|uno||three^^^^|four^^^|^cuatro|"
        )
    )


# MAIN ---
if __name__ == '__main__':
    main()
