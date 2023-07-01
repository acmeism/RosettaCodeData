# fiveNums :: [Float] -> (Float, Float, Float, Float, Float)
def fiveNums(xs):
    def median(xs):
        lng = len(xs)
        m = lng // 2
        return xs[m] if (
            0 != lng % 2
        ) else (xs[m - 1] + xs[m]) / 2

    ys = sorted(xs)
    lng = len(ys)
    m = lng // 2
    return (
        ys[0],
        median(ys[0:(m + (lng % 2))]),
        median(ys),
        median(ys[m:]),
        ys[-1]
    ) if 0 < lng else None


# TEST --------------------------------------------------------------------
for xs in [[15, 6, 42, 41, 7, 36, 49, 40, 39, 47, 43],
           [36, 40, 7, 39, 41, 15],
           [
               0.14082834, 0.09748790, 1.73131507, 0.87636009, -1.95059594,
               0.73438555, -0.03035726, 1.46675970, -0.74621349, -0.72588772,
               0.63905160, 0.61501527, -0.98983780, -1.00447874, -0.62759469,
               0.66206163, 1.04312009, -0.10305385, 0.75775634, 0.32566578
           ]]:
    print(
        fiveNums(xs)
    )
