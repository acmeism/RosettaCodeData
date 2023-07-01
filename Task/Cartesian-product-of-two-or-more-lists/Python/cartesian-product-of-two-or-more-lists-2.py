# ap (<*>) :: [(a -> b)] -> [a] -> [b]
def ap(fs):
    return lambda xs: foldl(
        lambda a: lambda f: a + foldl(
            lambda a: lambda x: a + [f(x)])([])(xs)
    )([])(fs)
