from itertools import (takewhile)


# lcp :: [String] -> String
def lcp(xs):
    return ''.join(
        x[0] for x in takewhile(allSame, transpose(xs))
    )


# TEST --------------------------------------------------

# main :: IO ()
def main():
    def showPrefix(xs):
        return ''.join(
            ['[' + ', '.join(xs), '] -> ', lcp(xs)]
        )

    print (*list(map(showPrefix, [
        ["interspecies", "interstellar", "interstate"],
        ["throne", "throne"],
        ["throne", "dungeon"],
        ["cheese"],
        [""],
        ["prefix", "suffix"],
        ["foo", "foobar"]])), sep='\n'
    )


# GENERIC FUNCTIONS -------------------------------------


# allSame :: [a] -> Bool
def allSame(xs):
    if 0 < len(xs):
        x = xs[0]
        return all(map(lambda y: x == y, xs))
    else:
        return True


# transpose :: [[a]] -> [[a]]
def transpose(xs):
    return map(list, zip(*xs))


# TEST ---
if __name__ == '__main__':
    main()
