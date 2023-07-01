# nAryCartProd :: [[a], [b], [c] ...] -> [(a, b, c ...)]
def nAryCartProd(xxs):
    return foldl1(cartesianProduct)(
        xxs
    )
