'''Comments stripped with itertools.takewhile'''

from itertools import takewhile


# stripComments :: [Char] -> String -> String
def stripComments(cs):
    '''The lines of the input text, with any
       comments (defined as starting with one
       of the characters in cs) stripped out.
    '''
    def go(cs):
        return lambda s: ''.join(
            takewhile(lambda c: c not in cs, s)
        ).strip()
    return lambda txt: '\n'.join(map(
        go(cs),
        txt.splitlines()
    ))


if __name__ == '__main__':
    print(
        stripComments(';#')(
            '''apples, pears # and bananas
               apples, pears ; and bananas
            '''
        )
    )
