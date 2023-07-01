def token_with_escape(a, escape = '^', separator = '|'):
    '''
        Issue  python -m doctest thisfile.py  to run the doctests.

        >>> print(token_with_escape('one^|uno||three^^^^|four^^^|^cuatro|'))
        ['one|uno', '', 'three^^', 'four^|cuatro', '']
    '''
    result = []
    token = ''
    state = 0
    for c in a:
        if state == 0:
            if c == escape:
                state = 1
            elif c == separator:
                result.append(token)
                token = ''
            else:
                token += c
        elif state == 1:
            token += c
            state = 0
    result.append(token)
    return result
