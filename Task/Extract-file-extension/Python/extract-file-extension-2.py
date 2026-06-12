'''Obtaining OS-specific file extensions'''

import os
import re


# OS-INDEPENDENT CURRIED FUNCTION -------------------------

# takeExtension :: Regex String -> FilePath -> String
def takeExtension(charSet):
    '''The extension part (if any) of a file name.
       (Given a regex string representation of the
       character set accepted in extensions by the OS).'''
    def go(fp):
        m = re.search(
            r'\.[' + charSet + ']+$',
            (fp).split(os.sep)[-1]
        )
        return m[0] if m else ''
    return lambda fp: go(fp)


# DERIVED (OS-SPECIFIC) FUNCTIONS -------------------------


# takePosixExtension :: FilePath -> String
def takePosixExtension(fp):
    '''The file extension, if any,
       of a Posix file path.'''
    return takeExtension(r'A-Za-z0-9\-\_')(fp)


# takeWindowsExtension :: FilePath -> String
def takeWindowsExtension(fp):
    '''The file extension, if any,
       of a Windows file path.'''
    return takeExtension(r'A-Za-z0-9')(fp)


# TEST ----------------------------------------------------
def main():
    '''Tests'''

    for f in [takePosixExtension, takeWindowsExtension]:
        print(
            tabulated(f.__name__ + ' :: FilePath -> String:')(
                str
            )(str)(f)([
                "http://example.com/download.tar.gz",
                "CharacterModel.3DS",
                ".desktop",
                "document",
                "document.txt_backup",
                "/etc/pam.d/login"
            ])
        )
        print()


# GENERIC -------------------------------------------------


# tabulated :: String -> (a -> String) ->
#                        (b -> String) ->
#                        (a -> b) -> [a] -> String
def tabulated(s):
    '''Heading -> x display function -> fx display function ->
          number of columns -> f -> value list -> tabular string.'''
    def go(xShow, fxShow, f, xs):
        w = max(map(lambda x: len(xShow(x)), xs))
        return s + '\n' + '\n'.join([
            xShow(x).rjust(w, ' ') + ' -> ' + fxShow(f(x)) for x in xs
        ])
    return lambda xShow: lambda fxShow: (
        lambda f: lambda xs: go(
            xShow, fxShow, f, xs
        )
    )


# MAIN ---
if __name__ == '__main__':
    main()
