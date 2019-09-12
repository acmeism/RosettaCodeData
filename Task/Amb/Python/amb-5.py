from itertools import chain


# amb :: [a] -> (a -> [b]) -> [b]
def amb(xs):
    return lambda f: list(
        chain.from_iterable(
            map(f, xs)
        )
    )


# when :: Bool -> [a] -> [a]
def when(p):
    return lambda xs: xs if p else []


# TEST ----------------------------------------------------

# joins :: String -> String -> Bool
def joins(a, b):
    return a[-1] == b[0]


print (
    amb(['the', 'that', 'a'])(
        lambda w1: when(True)

        (amb(['frog', 'elephant', 'thing'])
         (lambda w2: when(joins(w1, w2))

          (amb(['walked', 'treaded', 'grows'])
           (lambda w3: when(joins(w2, w3))

            (amb(['slowly', 'quickly'])
             (lambda w4: when(joins(w3, w4))(

                 [w1, w2, w3, w4]
             ))))))
         )
    )
)
