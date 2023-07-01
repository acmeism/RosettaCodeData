'''Check for a specific set of file extensions'''


# extensionFound :: [Extension] -> FileName -> Maybe Extension
def extensionFound(xs):
    '''Nothing if no matching extension is found,
       or Just the extension (drawn from xs, and
       a suffix of the filename, immediately following
       a dot character).
    '''
    return lambda fn: find(fn.lower().endswith)(
        ['.' + x.lower() for x in xs]
    )


# TEST ----------------------------------------------------
# main :: IO ()
def main():
    '''Check filenames for a particular set of extensions.'''

    # checkExtension :: FileName -> Maybe Extension
    def checkExtension(fn):
        return extensionFound([
            'zip', 'rar', '7z', 'gz', 'archive', 'A##', 'tar.bz2'
        ])(fn)

    print(
        fTable(__doc__ + ':\n')(str)(str)(
            compose(fromMaybe('n/a'))(checkExtension)
        )([
            'MyData.a##',
            'MyData.tar.Gz',
            'MyData.gzip',
            'MyData.7z.backup',
            'MyData...',
            'MyData',
            'MyData_v1.0.tar.bz2',
            'MyData_v1.0.bz2'
        ])
    )


# GENERIC -------------------------------------------------

# Just :: a -> Maybe a
def Just(x):
    '''Constructor for an inhabited Maybe (option type) value.'''
    return {'type': 'Maybe', 'Nothing': False, 'Just': x}


# Nothing :: Maybe a
def Nothing():
    '''Constructor for an empty Maybe (option type) value.'''
    return {'type': 'Maybe', 'Nothing': True}


# compose (<<<) :: (b -> c) -> (a -> b) -> a -> c
def compose(g):
    '''Right to left function composition.'''
    return lambda f: lambda x: g(f(x))


# find :: (a -> Bool) -> [a] -> Maybe a
def find(p):
    '''Just the first element in the list that matches p,
       or Nothing if no elements match.
    '''
    def go(xs):
        for x in xs:
            if p(x):
                return Just(x)
        return Nothing()
    return lambda xs: go(xs)


# fromMaybe :: a -> Maybe a -> a
def fromMaybe(x):
    '''The default value x if mb is Nothing,
       or the value contained in mb.
    '''
    return lambda mb: x if (
        mb.get('Nothing')
    ) else mb.get('Just')


# DISPLAY -------------------------------------------------

# fTable :: String -> (a -> String) ->
#                     (b -> String) -> (a -> b) -> [a] -> String
def fTable(s):
    '''Heading -> x display function -> fx display function ->
                     f -> xs -> tabular string.
    '''
    def go(xShow, fxShow, f, xs):
        ys = [xShow(x) for x in xs]
        w = max(map(len, ys))
        return s + '\n' + '\n'.join(map(
            lambda x, y: y.rjust(w, ' ') + ' -> ' + fxShow(f(x)),
            xs, ys
        ))
    return lambda xShow: lambda fxShow: lambda f: lambda xs: go(
        xShow, fxShow, f, xs
    )


# MAIN ---
if __name__ == '__main__':
    main()
