'''Sort an outline at every level'''


from itertools import chain, product, takewhile, tee
from functools import cmp_to_key, reduce


# ------------- OUTLINE SORTED AT EVERY LEVEL --------------

# sortedOutline :: (Tree String -> Tree String -> Ordering)
#                     -> String
#                     -> Either String String
def sortedOutline(cmp):
    '''Either a message reporting inconsistent
       indentation, or an outline sorted at every
       level by the supplied comparator function.
    '''
    def go(outlineText):
        indentTuples = indentTextPairs(
            outlineText.splitlines()
        )
        return bindLR(
            minimumIndent(enumerate(indentTuples))
        )(lambda unitIndent: Right(
            outlineFromForest(
                unitIndent,
                nest(foldTree(
                    lambda x: lambda xs: Node(x)(
                        sorted(xs, key=cmp_to_key(cmp))
                    )
                )(Node('')(
                    forestFromIndentLevels(
                        indentLevelsFromLines(
                            unitIndent
                        )(indentTuples)
                    )
                )))
            )
        ))
    return go


# -------------------------- TEST --------------------------
# main :: IO ()
def main():
    '''Ascending and descending sorts attempted on
       space-indented and tab-indented outlines, both
       well-formed and ill-formed.
    '''

    ascending = comparing(root)
    descending = flip(ascending)

    spacedOutline = '''
zeta
    beta
    gamma
        lambda
        kappa
        mu
    delta
alpha
    theta
    iota
    epsilon'''

    tabbedOutline = '''
zeta
	beta
	gamma
		lambda
		kappa
		mu
	delta
alpha
	theta
	iota
	epsilon'''

    confusedOutline = '''
alpha
    epsilon
	iota
    theta
zeta
    beta
    delta
    gamma
    	kappa
        lambda
        mu'''

    raggedOutline = '''
zeta
    beta
   gamma
        lambda
         kappa
        mu
    delta
alpha
    theta
    iota
    epsilon'''

    def displaySort(kcmp):
        '''Sort function output with labelled comparator
           for a set of four labelled outlines.
        '''
        k, cmp = kcmp
        return [
            tested(cmp, k, label)(
                outline
            ) for (label, outline) in [
                ('4-space indented', spacedOutline),
                ('tab indented', tabbedOutline),
                ('Unknown 1', confusedOutline),
                ('Unknown 2', raggedOutline)
            ]
        ]

    def tested(cmp, cmpName, outlineName):
        '''Print either message or result.
        '''
        def go(outline):
            print('\n' + outlineName, cmpName + ':')
            either(print)(print)(
                sortedOutline(cmp)(outline)
            )
        return go

    # Tests applied to two comparators:
    ap([
        displaySort
    ])([
        ("(A -> Z)", ascending),
        ("(Z -> A)", descending)
    ])


# ------------- OUTLINE PARSING AND RENDERING --------------

# forestFromIndentLevels :: [(Int, a)] -> [Tree a]
def forestFromIndentLevels(tuples):
    '''A list of trees derived from a list of values paired
       with integers giving their levels of indentation.
    '''
    def go(xs):
        if xs:
            intIndent, v = xs[0]
            firstTreeLines, rest = span(
                lambda x: intIndent < x[0]
            )(xs[1:])
            return [Node(v)(go(firstTreeLines))] + go(rest)
        else:
            return []
    return go(tuples)


# indentLevelsFromLines :: String -> [(String, String)]
# -> [(Int, String)]
def indentLevelsFromLines(indentUnit):
    '''Each input line stripped of leading
       white space, and tupled with a preceding integer
       giving its level of indentation from 0 upwards.
    '''
    def go(xs):
        w = len(indentUnit)
        return [
            (len(x[0]) // w, x[1])
            for x in xs
        ]
    return go


# indentTextPairs :: [String] -> (String, String)
def indentTextPairs(xs):
    '''A list of (indent, bodyText) pairs.'''
    def indentAndText(s):
        pfx = list(takewhile(lambda c: c.isspace(), s))
        return (pfx, s[len(pfx):])
    return [indentAndText(x) for x in xs]


# outlineFromForest :: String -> [Tree String] -> String
def outlineFromForest(tabString, forest):
    '''An indented outline serialisation of forest,
       using tabString as the unit of indentation.
    '''
    def go(indent):
        def serial(node):
            return [indent + root(node)] + list(
                concatMap(
                    go(tabString + indent)
                )(nest(node))
            )
        return serial
    return '\n'.join(
        concatMap(go(''))(forest)
    )


# --------------- MINIMUM INDENT, OR ANOMALY ---------------

# minimumIndent :: [(Int, [Char])]
#       -> Either String String
def minimumIndent(indexedPrefixes):
    '''Either a message, if indentation characters are
       mixed, or indentation widths are inconsistent,
       or the smallest consistent non-empty indentation.
    '''
    (xs, ts) = tee(indexedPrefixes)
    (ys, zs) = tee(ts)

    def mindentLR(charSet):
        if list(charSet):
            def w(x):
                return len(x[1][0])

            unit = min(filter(w, ys), key=w)[1][0]
            unitWidth = len(unit)

            def widthCheck(a, ix):
                '''Is there a line number at which
                   an anomalous indent width is seen?
                '''
                wx = len(ix[1][0])
                return a if (a or 0 == wx) else (
                    ix[0] if 0 != wx % unitWidth else a
                )
            oddLine = reduce(widthCheck, zs, None)
            return Left(
                'Inconsistent indentation width at line ' + (
                    str(1 + oddLine)
                )
            ) if oddLine else Right(''.join(unit))
        else:
            return Right('')

    def tabSpaceCheck(a, ics):
        '''Is there a line number at which a
           variant indent character is used?
        '''
        charSet = a[0].union(set(ics[1][0]))
        return a if a[1] else (
            charSet, ics[0] if 1 < len(charSet) else None
        )

    indentCharSet, mbAnomalyLine = reduce(
        tabSpaceCheck, xs, (set([]), None)
    )
    return bindLR(
        Left(
            'Mixed indent characters found in line ' + str(
                1 + mbAnomalyLine
            )
        ) if mbAnomalyLine else Right(list(indentCharSet))
    )(mindentLR)


# ------------------------ GENERIC -------------------------

# Left :: a -> Either a b
def Left(x):
    '''Constructor for an empty Either (option type) value
       with an associated string.
    '''
    return {'type': 'Either', 'Right': None, 'Left': x}


# Right :: b -> Either a b
def Right(x):
    '''Constructor for a populated Either (option type) value'''
    return {'type': 'Either', 'Left': None, 'Right': x}


# Node :: a -> [Tree a] -> Tree a
def Node(v):
    '''Constructor for a Tree node which connects a
       value of some kind to a list of zero or
       more child trees.
    '''
    return lambda xs: {'type': 'Tree', 'root': v, 'nest': xs}


# ap (<*>) :: [(a -> b)] -> [a] -> [b]
def ap(fs):
    '''The application of each of a list of functions,
       to each of a list of values.
    '''
    def go(xs):
        return [
            f(x) for (f, x)
            in product(fs, xs)
        ]
    return go


# bindLR (>>=) :: Either a -> (a -> Either b) -> Either b
def bindLR(m):
    '''Either monad injection operator.
       Two computations sequentially composed,
       with any value produced by the first
       passed as an argument to the second.
    '''
    def go(mf):
        return (
            mf(m.get('Right')) if None is m.get('Left') else m
        )
    return go


# comparing :: (a -> b) -> (a -> a -> Ordering)
def comparing(f):
    '''An ordering function based on
       a property accessor f.
    '''
    def go(x, y):
        fx = f(x)
        fy = f(y)
        return -1 if fx < fy else (1 if fx > fy else 0)
    return go


# concatMap :: (a -> [b]) -> [a] -> [b]
def concatMap(f):
    '''A concatenated list over which a function has been mapped.
       The list monad can be derived by using a function f which
       wraps its output in a list,
       (using an empty list to represent computational failure).
    '''
    def go(xs):
        return chain.from_iterable(map(f, xs))
    return go


# either :: (a -> c) -> (b -> c) -> Either a b -> c
def either(fl):
    '''The application of fl to e if e is a Left value,
       or the application of fr to e if e is a Right value.
    '''
    return lambda fr: lambda e: fl(e['Left']) if (
        None is e['Right']
    ) else fr(e['Right'])


# flip :: (a -> b -> c) -> b -> a -> c
def flip(f):
    '''The binary function f with its
       arguments reversed.
    '''
    return lambda a, b: f(b, a)


# foldTree :: (a -> [b] -> b) -> Tree a -> b
def foldTree(f):
    '''The catamorphism on trees. A summary
       value defined by a depth-first fold.
    '''
    def go(node):
        return f(root(node))([
            go(x) for x in nest(node)
        ])
    return go


# nest :: Tree a -> [Tree a]
def nest(t):
    '''Accessor function for children of tree node.'''
    return t.get('nest')


# root :: Tree a -> a
def root(t):
    '''Accessor function for data of tree node.'''
    return t.get('root')


# span :: (a -> Bool) -> [a] -> ([a], [a])
def span(p):
    '''The longest (possibly empty) prefix of xs
       that contains only elements satisfying p,
       tupled with the remainder of xs.
       span p xs is equivalent to
       (takeWhile p xs, dropWhile p xs).
    '''
    def match(ab):
        b = ab[1]
        return not b or not p(b[0])

    def f(ab):
        a, b = ab
        return a + [b[0]], b[1:]

    def go(xs):
        return until(match)(f)(([], xs))
    return go


# until :: (a -> Bool) -> (a -> a) -> a -> a
def until(p):
    '''The result of repeatedly applying f until p holds.
       The initial seed value is x.
    '''
    def go(f):
        def g(x):
            v = x
            while not p(v):
                v = f(v)
            return v
        return g
    return go


# MAIN ---
if __name__ == '__main__':
    main()
