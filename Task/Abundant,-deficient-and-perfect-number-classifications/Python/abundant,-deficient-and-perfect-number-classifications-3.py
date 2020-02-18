# nthArrow :: (a -> b) -> Tuple -> Int -> Tuple
def nthArrow(f):
    '''A simple function lifted to one which applies to a
       tuple, transforming only its nth value.
    '''
    def go(v, n):
        m = n - 1
        return v if n > len(v) else [
            x if m != i else f(x) for i, x in enumerate(v)
        ]
    return lambda tpl: lambda n: tuple(go(tpl, n))
