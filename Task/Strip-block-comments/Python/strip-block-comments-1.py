def _commentstripper(txt, delim):
    'Strips first nest of block comments'

    deliml, delimr = delim
    out = ''
    if deliml in txt:
        indx = txt.index(deliml)
        out += txt[:indx]
        txt = txt[indx+len(deliml):]
        txt = _commentstripper(txt, delim)
        assert delimr in txt, 'Cannot find closing comment delimiter in ' + txt
        indx = txt.index(delimr)
        out += txt[(indx+len(delimr)):]
    else:
        out = txt
    return out

def commentstripper(txt, delim=('/*', '*/')):
    'Strips nests of block comments'

    deliml, delimr = delim
    while deliml in txt:
        txt = _commentstripper(txt, delim)
    return txt
