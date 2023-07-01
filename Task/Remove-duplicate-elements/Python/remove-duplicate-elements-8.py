# nubBy :: (a -> a -> Bool) -> [a] -> [a]
def nubBy(p, xs):
    def go(xs):
        if xs:
            x = xs[0]
            return [x] + go(
                list(filter(
                    lambda y: not p(x, y),
                    xs[1:]
                ))
            )
        else:
            return []
    return go(xs)
