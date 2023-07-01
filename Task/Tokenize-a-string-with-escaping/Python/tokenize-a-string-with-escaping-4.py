import re

STRING = 'one^|uno||three^^^^|four^^^|^cuatro|'

def tokenize(string=STRING, escape='^', separator='|'):

    re_escape, re_separator = map(re.escape, (escape, separator))

    # token regex
    regex = re.compile(fr'''
        # lookbehind: a token must be preceded by a separator
        # (note that `(?<=^|{re_separator})` doesn't work in Python)
        (?<={re_separator})

        # a token consists either of an escape sequence,
        # or a regular (non-escape, non-separator) character,
        # repeated arbitrarily many times (even zero)
        (?:{re_escape}.|[^{re_escape}{re_separator}])*
      ''',
      flags=re.VERBOSE
    )

    # since each token must start with a separator,
    # we must add an extra separator at the beginning of input
    preprocessed_string = separator + string

    for almost_token in regex.findall(preprocessed_string):
      # now get rid of escape characters: '^^' -> '^' etc.
      token = re.sub(fr'{re_escape}(.)', r'\1', almost_token)
      yield token

if __name__ == '__main__':
    print(list(tokenize()))
