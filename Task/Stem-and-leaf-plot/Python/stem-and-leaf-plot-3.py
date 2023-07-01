from itertools import (groupby)
from functools import (reduce)


# stemLeaf :: (String -> Int) -> (String -> String) -> String -> String
def stemLeaf(f, g, s):
    return '\n'.join(map(
        lambda x: str(x[0]).rjust(2) + ' | ' +
        reduce(lambda a, tpl: a + tpl[1] + ' ', x[1], ''),
        (groupby(sorted(
            map(lambda x: (f(x), g(x)), s.split())
        ),
            lambda x: x[0]
        ))
    ))


# main :: IO()
def main():
    def stem(s):
        return (lambda x=s[:-1]: int(x) if 0 < len(x) else 0)()

    def leaf(s):
        return s[-1]

    s = ('12 127 28 42 39 113 42 18 44 118 44 37 113 124 37 48 127 36 29 31'
         ' 125 139 131 115 105 132 104 123 35 113 122 42 117 119 58 109 23'
         ' 105 63 27 44 105 99 41 128 121 116 125 32 61 37 127 29 113 121 58'
         ' 114 126 53 114 96 25 109 7 31 141 46 13 27 43 117 116 27 7 68 40'
         ' 31 115 124 42 128 52 71 118 117 38 27 106 33 117 116 111 40 119 47'
         ' 105 57 122 109 124 115 43 120 43 27 27 18 28 48 125 107 114 34 133'
         ' 45 120 30 127 31 116 146')

    print (stemLeaf(stem, leaf, s))


main()
