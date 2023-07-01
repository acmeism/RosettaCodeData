'''S-expressions'''

from itertools import chain, repeat
import re


def main():
    '''Sample s-expression parsed, diagrammed,
       and reserialized from the parse tree.
    '''
    expr = "((data \"quoted data\" 123 4.5)\n" + (
        "  (data (!@# (4.5) \"(more\" \"data)\")))"
    )
    parse = parseExpr(tokenized(expr))[0]
    print(
        drawForest([
            fmapTree(str)(tree) for tree
            in forestFromExprs(parse)
        ])
    )
    print(
        f'\nReserialized from parse:\n\n{serialized(parse)}'
    )


# ----------------- S-EXPRESSION PARSER ------------------

# parseExpr :: [String] -> ([Expr], [String]
def parseExpr(tokens):
    '''A tuple of a nested list with any
       unparsed tokens that remain.
    '''
    return until(finished)(parseToken)(
        ([], tokens)
    )


# finished :: ([Expr], [String]) -> Bool
def finished(xr):
    '''True if no tokens remain,
       or the next token is a closing bracket.
    '''
    r = xr[1]
    return (not r) or (r[0] == ")")


# parseToken :: ([Expr], [String]) -> ([Expr], [String])
def parseToken(xsr):
    '''A tuple of an expanded expression list
       and a reduced token list.
    '''
    xs, r = xsr
    h, *t = r
    if "(" == h:
        expr, rest = parseExpr(t)
        return xs + [expr], rest[1:]
    else:
        return (xs, t) if ")" == h else (
            xs + [atom(h)], t
        )

# --------------------- ATOM PARSER ----------------------

# atom :: String -> Expr
def atom(s):
    '''A Symbol, String, Float, or Int derived from s.
       Symbol is represented as a dict with a 'name' key.
    '''
    def n(k):
        return float(k) if '.' in k else int(k)

    return s if '"' == s[0] else (
        n(s) if s.replace('.', '', 1).isdigit() else {
            "name": s
        }
    )


# --------------------- TOKENIZATION ---------------------

# tokenized :: String -> [String]
def tokenized(s):
    '''A list of the tokens in s.
    '''
    return list(chain.from_iterable(map(
        lambda token: [token] if '"' == token[0] else (
            x for x in re.split(
                r'\s+',
                re.sub(r"([()])", r" \1 ", token)
            ) if x
        ) if token else [], (
            x if (0 == i % 2) else f'"{x}"'
            for (i, x) in enumerate(s.split('"'))
        )
    )))


# -------------------- SERIALIZATION ---------------------

# serialized :: Expr -> String
def serialized(e):
    '''An s-expression written out from the parse tree.
    '''
    k = typename(e)

    return str(e) if k in ['int', 'float', 'str'] else (
        (
            f'({" ".join([serialized(x) for x in e])})' if (
                (1 < len(e)) or ('list' != typename(e[0]))
            ) else serialized(e[0])
        ) if 'list' == k else (
            e.get("name") if 'dict' == k else "?"
        )
    )


# typename :: a -> String
def typename(x):
    '''Name property of the type of a value.'''
    return type(x).__name__


# ------------------- TREE DIAGRAMMING -------------------

# Node :: a -> [Tree a] -> Tree a
def Node(v):
    '''Constructor for a Tree node which connects a
       value of some kind to a list of zero or
       more child trees.
    '''
    return lambda xs: {'type': 'Tree', 'root': v, 'nest': xs}


# append :: [a] -> [a] -> [a]
def append(a, b):
    '''Concatenation.'''
    return a + b


# draw :: Tree a -> [String]
def draw(node):
    '''List of the lines of an ASCII
       diagram of a tree.
    '''
    def shift_(h, other, xs):
        return list(map(
            append,
            chain(
                [h], (
                    repeat(other, len(xs) - 1)
                )
            ),
            xs
        ))

    def drawSubTrees(xs):
        return (
            (
                ['|'] + shift_(
                    '├─ ', '│  ', draw(xs[0])
                ) + drawSubTrees(xs[1:])
            ) if 1 < len(xs) else ['|'] + shift_(
                '└─ ', '   ', draw(xs[0])
            )
        ) if xs else []

    return (root(node)).splitlines() + (
        drawSubTrees(nest(node))
    )


# drawForest :: [Tree String] -> String
def drawForest(trees):
    '''A simple unicode character representation of
       a list of trees.
    '''
    return '\n'.join(map(drawTree, trees))


# drawTree :: Tree a -> String
def drawTree(tree):
    '''ASCII diagram of a tree.'''
    return '\n'.join(draw(tree))


# fmapTree :: (a -> b) -> Tree a -> Tree b
def fmapTree(f):
    '''A new tree holding the results of
       an application of f to each root in
       the existing tree.
    '''
    def go(x):
        return Node(
            f(root(x))
        )([go(v) for v in nest(x)])
    return go


# forestFromExprs :: [Expr] -> [Tree Expr]
def forestFromExprs(es):
    '''A list of expressions rewritten as a forest.
    '''
    return [treeFromExpr(x) for x in es]


# nest :: Tree a -> [Tree a]
def nest(t):
    '''Accessor function for children of tree node.'''
    return t.get('nest')


# root :: Tree a -> a
def root(t):
    '''Accessor function for data of tree node.'''
    return t.get('root')


# treeFromExprs :: Expr -> Tree Expr
def treeFromExpr(e):
    '''An expression rewritten as a tree.
    '''
    return (
        Node({"name": "List"})(forestFromExprs(e))
    ) if type(e) is list else (
        Node(e)([])
    )


# ----------------------- GENERIC ------------------------

# until :: (a -> Bool) -> (a -> a) -> a -> a
def until(p):
    '''The result of repeatedly applying f until p holds.
       The initial seed value is x.
    '''
    def go(f):
        def loop(x):
            v = x
            while not p(v):
                v = f(v)
            return v
        return loop
    return go


# MAIN ---
if __name__ == '__main__':
    main()
