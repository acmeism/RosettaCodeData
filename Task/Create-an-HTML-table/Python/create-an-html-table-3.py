from functools import (reduce)
import itertools
import random


# HTML RENDERING ----------------------------------------

# treeHTML :: tree
#      {tag :: String, text :: String, kvs :: Dict}
#      -> HTML String
def treeHTML(tree):
    return foldTree(
        lambda x: lambda xs: (
            f"<{x['tag'] + attribString(x)}>" + (
                str(x['text']) if 'text' in x else '\n'
            ) + ''.join(xs) + f"</{x['tag']}>\n"
        )
    )(tree)


# attribString :: Dict -> String
def attribString(dct):
    kvs = dct['kvs'] if 'kvs' in dct else None
    return ' ' + reduce(
        lambda a, k: a + k + '="' + kvs[k] + '" ',
        kvs.keys(), ''
    ).strip() if kvs else ''


# HTML TABLE FROM GENERATED DATA ------------------------


def main():
    # Number of columns and rows to generate.
    n = 3

    # Table details -------------------------------------
    strCaption = 'Table generated with Python'
    colNames = take(n)(enumFrom('A'))
    dataRows = map(
        lambda x: (x, map(
            lambda _: random.randint(100, 9999),
            colNames
        )), take(n)(enumFrom(1)))
    tableStyle = {
        'style': "width:25%; border:2px solid silver;"
    }
    trStyle = {
        'style': "border:1px solid silver;text-align:right;"
    }

    # TREE STRUCTURE OF TABLE ---------------------------
    tableTree = Node({'tag': 'table', 'kvs': tableStyle})([
        Node({
            'tag': 'caption',
            'text': strCaption
        })([]),

        # HEADER ROW --------------------------------
        (Node({'tag': 'tr'})(
            Node({
                'tag': 'th',
                'kvs': {'style': 'text-align:right;'},
                'text': k
            })([]) for k in ([''] + colNames)
        ))
    ] +
        # DATA ROWS ---------------------------------
        list(Node({'tag': 'tr', 'kvs': trStyle})(
            [Node({'tag': 'th', 'text': tpl[0]})([])] +
            list(Node(
                {'tag': 'td', 'text': str(v)})([]) for v in tpl[1]
            )
        ) for tpl in dataRows)
    )

    print(
        treeHTML(tableTree)
        # dataRows
    )


# GENERIC -----------------------------------------------

# Node :: a -> [Tree a] -> Tree a
def Node(v):
    return lambda xs: {'type': 'Node', 'root': v, 'nest': xs}


# enumFrom :: Enum a => a -> [a]
def enumFrom(x):
    return itertools.count(x) if type(x) is int else (
        map(chr, itertools.count(ord(x)))
    )


# foldTree :: (a -> [b] -> b) -> Tree a -> b
def foldTree(f):
    def go(node):
        return f(node['root'])(
            list(map(go, node['nest']))
        )
    return lambda tree: go(tree)


# take :: Int -> [a] -> [a]
# take :: Int -> String -> String
def take(n):
    return lambda xs: (
        xs[0:n]
        if isinstance(xs, list)
        else list(itertools.islice(xs, n))
    )


if __name__ == '__main__':
    main()
