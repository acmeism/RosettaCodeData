# inconsistentChar :: String -> Maybe (Int, Char)
def inconsistentChar(s):
    '''Just the first inconsistent character and its index,
       or Nothing if all the characters of s are the same.
    '''
    return next(
        (Just(ix) for ix in enumerate(s) if s[0] != ix[1]),
        Nothing()
    )
