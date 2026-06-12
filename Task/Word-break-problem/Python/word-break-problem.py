'''Parsing a string for word breaks'''

from itertools import (chain)


# stringParse :: [String] -> String -> Tree String
def stringParse(lexicon):
    '''A tree of strings representing a parse of s
       in terms of the tokens in lexicon.
    '''
    return lambda s: Node(s)(
        tokenTrees(lexicon)(s)
    )


# tokenTrees :: [String] -> String -> [Tree String]
def tokenTrees(wds):
    '''A list of possible parse trees for s,
       based on the lexicon supplied in wds.
    '''
    def go(s):
        return [Node(s)([])] if s in wds else (
            concatMap(nxt(s))(wds)
        )

    def nxt(s):
        return lambda w: parse(
            w, go(s[len(w):])
        ) if s.startswith(w) else []

    def parse(w, xs):
        return [Node(w)(xs)] if xs else xs

    return lambda s: go(s)


# showParse :: Tree String -> String
def showParse(tree):
    '''Multi line display of a string followed by any
       possible parses of it, or an explanatory
       message, if no parse was possible.
    '''
    def showTokens(x):
        xs = x['nest']
        return ' ' + x['root'] + (showTokens(xs[0]) if xs else '')
    parses = tree['nest']
    return tree['root'] + ':\n' + (
        '\n'.join(
            map(showTokens, parses)
        ) if parses else ' ( Not parseable in terms of these words )'
    )


# TEST -------------------------------------------------
# main :: IO ()
def main():
    '''Parse test and display of results.'''

    lexicon = 'a bc abc cd b'.split()
    testSamples = 'abcd abbc abcbcd acdbc abcdd'.split()

    print(unlines(
        map(
            showParse,
            map(
                stringParse(lexicon),
                testSamples
            )
        )
    ))


# GENERIC FUNCTIONS ---------------------------------------

# Node :: a -> [Tree a] -> Tree a
def Node(v):
    '''Contructor for a Tree node which connects a
       value of some kind to a list of zero or
       more child trees.'''
    return lambda xs: {'type': 'Node', 'root': v, 'nest': xs}


# concatMap :: (a -> [b]) -> [a] -> [b]
def concatMap(f):
    '''A concatenated list over which a function has been mapped.
       The list monad can be derived by using a function f which
       wraps its output in a list,
       (using an empty list to represent computational failure).'''
    return lambda xs: list(
        chain.from_iterable(map(f, xs))
    )


# unlines :: [String] -> String
def unlines(xs):
    '''A single string derived by the intercalation
       of a list of strings with the newline character.'''
    return '\n'.join(xs)


# MAIN ---
if __name__ == '__main__':
    main()
