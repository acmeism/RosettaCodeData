def splitterz(text):
    return (''.join(x + ('' if x == nxt else ', ')
            for x, nxt in zip(txt, txt[1:] + txt[-1])))

if __name__ == '__main__':
    txt = 'gHHH5YY++///\\'
    print(splitterz(txt))
