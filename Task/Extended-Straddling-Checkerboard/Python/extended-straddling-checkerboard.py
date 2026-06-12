""" rosettacode.org/wiki/Extended_Straddling_Checkerboard """

from functools import reduce

WDICT = {
    'CODE': 'κ',
    'ACK': 'α',
    'REQ': 'ρ',
    'MSG': 'μ',
    'RV': 'ν',
    'GRID': 'γ',
    'SEND': 'σ',
    'SUPP': 'π',
}
# reversed WDICT for reverse lookup on decode
SDICT = {v: k for (k, v) in WDICT.items()}

# CT37w at https://www.ciphermachinesandcryptology.com/en/table.htm
CT37w = [['',  'A', 'E', 'I', 'N', 'O', 'T', 'κ', '',  '',  '',],
         ['7', 'B', 'C', 'D', 'F', 'G', 'H', 'J', 'K', 'L', 'M',],
         ['8', 'P', 'Q', 'R', 'S', 'U', 'V', 'W', 'X', 'Y', 'Z',],
         ['9', ' ', '.', 'α', 'ρ', 'μ', 'ν', 'γ', 'σ', 'π', '/'],]

# Modified CT37w: web site CT37w, but exchange '/' (FIG) char and 'π'
# to help differentiate the '999' encoding for a '9' from a terminator code
CT37w_mod = [['',  'A', 'E', 'I', 'N', 'O', 'T', 'κ', '',  '',  '',],
             ['7', 'B', 'C', 'D', 'F', 'G', 'H', 'J', 'K', 'L', 'M',],
             ['8', 'P', 'Q', 'R', 'S', 'U', 'V', 'W', 'X', 'Y', 'Z',],
             ['9', ' ', '.', 'α', 'ρ', 'μ', 'ν', 'γ', 'σ', '/', 'π',],]


def xcb_encode(message, table=CT37w, code='κ', wdict=WDICT):
    """
        Encode with extended straddling checkerboard. Default checkerboard is
        CT37w at https://www.ciphermachinesandcryptology.com/en/table.htm
        The numeric mode has the numbers as repeated in triplicate
        The CODE mode expects a 3-digit numeric code
    """
    encoded = []
    numericmode, codemode = False, False
    codemodecount = 0
    if table[-1][-1] == '/':
        nchangemode = '99'
        digit_repeats = 3
    else:
        nchangemode = '98'
        digit_repeats = 2

    # replace terms found in dictionary with a single char symbol that is in the table
    s = reduce(lambda x, p: x.replace(
        p[0], p[1]), wdict.items(), message.upper())
    for c in s:
        if c.isnumeric():
            if codemode:  # codemode symbols are preceded by the CODE digit '6' then as-is
                encoded.append(c)
                codemodecount += 1
                if codemodecount >= 3:
                    codemode = False

            else:
                if not numericmode:
                    numericmode = True
                    encoded.append(nchangemode)  # FIG

                encoded.append(c*digit_repeats)

        else:
            codemode = False
            if numericmode:
                # end numericmode with the FIG numeric code for '/' (98)
                encoded.append(nchangemode)
                numericmode = False

            if c == code:
                codemode = True
                codemodecount = 0

            for row in table:
                if c in row:
                    k = row.index(c)
                    encoded.append(str(row[0]) + str(k-1))
                    break

    return ''.join(encoded)


def xcb_decode(s, table=CT37w, code='κ', sdict=SDICT):
    """ Decode extended straddling checkerboard """
    prefixes = sorted([row[0] for row in table], reverse=True)
    pos, numericmode, codemode = 0, False, False
    decoded = []
    if table[-1][-1] == '/':
        nchangemode = '99'
        digit_repeats = 3
    else:
        nchangemode = '98'
        digit_repeats = 2
    numbers = {c*digit_repeats: c for c in list('0123456789')}
    while pos < len(s):
        if numericmode:
            if s[pos:pos+digit_repeats] in numbers:
                decoded.append(numbers[s[pos:pos+digit_repeats]])
                pos += digit_repeats - 1
            elif s[pos:pos+2] == nchangemode:
                numericmode = False
                pos += 1
            elif decoded[-1] == '9':  # error, so backtrack if last was 9
                decoded.pop()
                numericmode = False
                pos -= digit_repeats - 1

        elif codemode:
            if (s[pos:pos+3]).isnumeric():
                decoded.append(s[pos:pos+3])
                pos += 2

            codemode = False

        elif s[pos:pos+2] == nchangemode:
            numericmode = not numericmode
            pos += 1

        else:
            for p in prefixes:
                if s[pos:].startswith(p):
                    n = len(p)
                    row = next(i for i, r in enumerate(table) if p == r[0])
                    c = table[row][int(s[pos+n])+1]
                    decoded.append(c)
                    if c == code:
                        codemode = True

                    pos += n
                    break

        pos += 1

    return reduce(lambda x, p: x.replace(p[0], p[1]), sdict.items(), ''.join(decoded))


if __name__ == '__main__':

    MESSAGE = 'Admin ACK your MSG. CODE291 SEND further 2000 SUPP to HQ by 1 March'
    print(MESSAGE)
    print('Encoded: ', xcb_encode(MESSAGE))
    print('Decoded: ', xcb_decode(xcb_encode(MESSAGE)))
    print('Encoded: ', xcb_encode(MESSAGE, CT37w_mod))
    print('Decoded: ', xcb_decode(xcb_encode(MESSAGE, CT37w_mod), CT37w_mod))

