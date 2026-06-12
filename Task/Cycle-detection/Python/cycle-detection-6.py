# until_ :: (a -> Bool) -> (a -> a) -> a -> a
def until_(p):
    '''The result of repeatedly applying f until p holds.
       The initial seed value is x.'''
    def go(f, x):
        v = x
        while not p(v):
            v = f(v)
        return v
    return lambda f: lambda x: go(f, x)
