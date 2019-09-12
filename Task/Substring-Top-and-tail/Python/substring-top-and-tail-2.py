from functools import (reduce)


def main():
    for xs in transpose(
        (chunksOf(3)(
            ap([tail, init, compose(init)(tail)])(
                ['knights', 'socks', 'brooms']
            )
        ))
    ):
        print(xs)


# GENERIC -------------------------------------------------

# tail :: [a] -> [a]
def tail(xs):
    return xs[1:]


# init::[a] - > [a]
def init(xs):
    return xs[:-1]


# ap (<*>) :: [(a -> b)] -> [a] -> [b]
def ap(fs):
    return lambda xs: reduce(
        lambda a, f: a + reduce(
            lambda a, x: a + [f(x)], xs, []
        ), fs, []
    )


# chunksOf :: Int -> [a] -> [[a]]
def chunksOf(n):
    return lambda xs: reduce(
        lambda a, i: a + [xs[i:n + i]],
        range(0, len(xs), n), []
    ) if 0 < n else []


# compose (<<<) :: (b -> c) -> (a -> b) -> a -> c
def compose(g):
    return lambda f: lambda x: g(f(x))


# transpose :: [[a]] -> [[a]]
def transpose(xs):
    return list(map(list, zip(*xs)))


if __name__ == '__main__':
    main()
