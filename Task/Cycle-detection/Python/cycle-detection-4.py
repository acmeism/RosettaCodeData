# until :: (a -> Bool) -> (a -> a) -> a -> a
def until(p):
    '''The result of repeatedly applying f until p holds.
       The initial seed value is x.'''
    def go(f, x):
        return x if p(x) else go(f, f(x))
    return lambda f: lambda x: go(f, x)
