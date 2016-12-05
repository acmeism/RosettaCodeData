'''
  Reverse a Unicode string with proper handling of combining characters
'''

import unicodedata

def ureverse(ustring):
    '''
    Reverse a string including unicode combining characters

    Example:
        >>> ucode = ''.join( chr(int(n, 16))
                             for n in ['61', '73', '20dd', '64', '66', '305'] )
        >>> ucoderev = ureverse(ucode)
        >>> ['%x' % ord(char) for char in ucoderev]
        ['66', '305', '64', '73', '20dd', '61']
        >>>
    '''
    groupedchars = []
    uchar = list(ustring)
    while uchar:
        if 'COMBINING' in unicodedata.name(uchar[0], ''):
            groupedchars[-1] += uchar.pop(0)
        else:
            groupedchars.append(uchar.pop(0))
    # Grouped reversal
    groupedchars = groupedchars[::-1]

    return ''.join(groupedchars)

if __name__ == '__main__':
    ucode = ''.join( chr(int(n, 16))
                     for n in ['61', '73', '20dd', '64', '66', '305'] )
    ucoderev = ureverse(ucode)
    print (ucode)
    print (ucoderev)
