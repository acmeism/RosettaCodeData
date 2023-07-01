'''Simple abbreviations'''

from functools import reduce
import re


# withExpansions :: [(String, Int)] -> String -> String
def withExpansions(table):
    '''A string in which all words are either
       expanded (if they match abbreviations in
       a supplied table), or replaced with an
       '*error*' string.
    '''
    return lambda s: unwords(map(
        expanded(table), words(s)
    ))


# expanded :: [(String, Int)] -> String -> String
def expanded(table):
    '''An abbreviation (or error string) for
       a given word, based on a table of full
       strings and minimum abbreviation lengths.
    '''
    def expansion(k):
        u = k.upper()
        lng = len(k)

        def p(wn):
            w, n = wn
            return w.startswith(u) and lng >= n
        return find(p)(table) if k else Just(('', 0))

    return lambda s: maybe('*error*')(fst)(expansion(s))


# cmdsFromString :: String -> [(String, Int)]
def cmdsFromString(s):
    '''A simple rule-base consisting of a
       list of tuples [(
          upper case expansion string,
          minimum character count of abbreviation
       )],
       obtained by a parse of single input string.
    '''
    def go(a, x):
        xs, n = a
        return (xs, int(x)) if x.isdigit() else (
            ([(x.upper(), n)] + xs, 0)
        )
    return fst(reduce(
        go,
        reversed(re.split(r'\s+', s)),
        ([], 0)
    ))


# TEST -------------------------------------------------
def main():
    '''Tests of abbreviation expansions'''

    # table :: [(String, Int)]
    table = cmdsFromString(
        '''add 1  alter 3  backup 2  bottom 1  Cappend 2  change 1
            Schange Cinsert 2  Clast 3 compress 4 copy 2 count 3 Coverlay 3
            cursor 3  delete 3 Cdelete 2  down 1  duplicate 3 xEdit 1 expand 3
            extract 3  find 1 Nfind 2 Nfindup 6 NfUP 3 Cfind 2 findUP 3 fUP 2
            forward 2  get  help 1 hexType 4 input 1 powerInput 3  join 1
            split 2 spltJOIN load locate 1 Clocate 2 lowerCase 3 upperCase 3
            Lprefix 2  macro  merge 2 modify 3 move 2 msg  next 1 overlay 1
            parse preserve 4 purge 3 put putD query 1 quit read recover 3
            refresh renum 3 repeat 3 replace 1 Creplace 2 reset 3 restore 4
            rgtLEFT right 2 left 2  save  set  shift 2  si  sort  sos stack 3
            status 4 top  transfer 3  type 1  up 1'''
    )

    # tests :: [String]
    tests = [
        'riG   rePEAT copies  put mo   rest    types   fup.    6      poweRin',
        ''
    ]

    print(
        fTable(__doc__ + ':\n')(lambda s: "'" + s + "'")(
            lambda s: "\n\t'" + s + "'"
        )(withExpansions(table))(tests)
    )


# GENERIC -------------------------------------------------

# compose (<<<) :: (b -> c) -> (a -> b) -> a -> c
def compose(g):
    '''Right to left function composition.'''
    return lambda f: lambda x: g(f(x))


# Just :: a -> Maybe a
def Just(x):
    '''Constructor for an inhabited Maybe (option type) value.'''
    return {'type': 'Maybe', 'Nothing': False, 'Just': x}


# Nothing :: Maybe a
def Nothing():
    '''Constructor for an empty Maybe (option type) value.'''
    return {'type': 'Maybe', 'Nothing': True}


# find :: (a -> Bool) -> [a] -> Maybe a
def find(p):
    '''Just the first element in the list that matches p,
       or Nothing if no elements match.'''
    def go(xs):
        for x in xs:
            if p(x):
                return Just(x)
        return Nothing()
    return lambda xs: go(xs)


# fst :: (a, b) -> a
def fst(tpl):
    '''First member of a pair.'''
    return tpl[0]


# fTable :: String -> (a -> String)
#                  -> (b -> String) -> (a -> b) -> [a] -> String
def fTable(s):
    '''Heading -> x display function ->
                 fx display function ->
          f -> value list -> tabular string.'''
    def go(xShow, fxShow, f, xs):
        w = max(map(compose(len)(xShow), xs))
        return s + '\n' + '\n'.join([
            xShow(x).rjust(w, ' ') + (' -> ') + fxShow(f(x))
            for x in xs
        ])
    return lambda xShow: lambda fxShow: lambda f: lambda xs: go(
        xShow, fxShow, f, xs
    )


# maybe :: b -> (a -> b) -> Maybe a -> b
def maybe(v):
    '''Either the default value v, if m is Nothing,
       or the application of f to x,
       where m is Just(x).'''
    return lambda f: lambda m: v if m.get('Nothing') else (
        f(m.get('Just'))
    )


# unwords :: [String] -> String
def unwords(xs):
    '''A space-separated string derived from
       a list of words.'''
    return ' '.join(xs)


# words :: String -> [String]
def words(s):
    '''A list of words delimited by characters
       representing white space.'''
    return re.split(r'\s+', s)


# MAIN ---
if __name__ == '__main__':
    main()
