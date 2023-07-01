'''Multisplit'''


from functools import reduce


# multiSplit :: [String] -> String -> [(String, String, Int)]
def multiSplit(separators):
    '''List of triples:
       [(token, separator, start index of separator].
    '''
    def go(s):
        def f(tokensPartsOffset, ic):
            tokens, parts, offset = tokensPartsOffset
            i, c = ic
            inDelim = offset > i
            return maybe(
                (
                    tokens if inDelim
                    else c + tokens, parts, offset
                )
            )(
                lambda x: (
                    '',
                    [(tokens, x, i)] + parts,
                    i + len(x)
                )
            )(
                None if inDelim else find(
                    s[i:].startswith
                )(separators)
            )
        ts, ps, _ = reduce(f, enumerate(s), ('', [], 0))
        return list(reversed(ps)) + [(ts, '', len(s))]
    return go


# ------------------------- TEST -------------------------
# main :: IO ()
def main():
    '''String split on three successive separators.'''
    print(
        multiSplit(['==', '!=', '='])(
            'a!===b=!=c'
        )
    )


# ------------------ GENERIC FUNCTIONS -------------------

# find :: (a -> Bool) -> [a] -> (a | None)
def find(p):
    '''Just the first element in the list that matches p,
       or None if no elements match.
    '''
    def go(xs):
        try:
            return next(x for x in xs if p(x))
        except StopIteration:
            return None
    return go


# maybe :: b -> (a -> b) -> (a | None) -> b
def maybe(v):
    '''Either the default value v, if m is None,
       or the application of f to x.
    '''
    return lambda f: lambda m: v if (
        None is m
    ) else f(m)


# MAIN ---
if __name__ == '__main__':
    main()
