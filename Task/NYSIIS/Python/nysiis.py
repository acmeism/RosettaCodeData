import re

_vowels = 'AEIOU'

def replace_at(text, position, fromlist, tolist):
    for f, t in zip(fromlist, tolist):
        if text[position:].startswith(f):
            return ''.join([text[:position],
                            t,
                            text[position+len(f):]])
    return text

def replace_end(text, fromlist, tolist):
    for f, t in zip(fromlist, tolist):
        if text.endswith(f):
            return text[:-len(f)] + t
    return text

def nysiis(name):
    name = re.sub(r'\W', '', name).upper()
    name = replace_at(name, 0, ['MAC', 'KN', 'K', 'PH', 'PF', 'SCH'],
                               ['MCC', 'N',  'C', 'FF', 'FF', 'SSS'])
    name = replace_end(name, ['EE', 'IE', 'DT', 'RT', 'RD', 'NT', 'ND'],
                             ['Y',  'Y',  'D',  'D',  'D',  'D',  'D'])
    key, key1 = name[0], ''
    i = 1
    while i < len(name):
        #print(i, name, key1, key)
        n_1, n = name[i-1], name[i]
        n1_ = name[i+1] if i+1 < len(name) else ''
        name = replace_at(name, i, ['EV'] + list(_vowels), ['AF'] + ['A']*5)
        name = replace_at(name, i, 'QZM', 'GSN')
        name = replace_at(name, i, ['KN', 'K'], ['N', 'C'])
        name = replace_at(name, i, ['SCH', 'PH'], ['SSS', 'FF'])
        if n == 'H' and (n_1 not in _vowels or n1_ not in _vowels):
            name = ''.join([name[:i], n_1, name[i+1:]])
        if n == 'W' and n_1 in _vowels:
            name = ''.join([name[:i], 'A', name[i+1:]])
        if key and key[-1] != name[i]:
            key += name[i]
        i += 1
    key = replace_end(key, ['S'], [''])
    key = replace_end(key, ['AY'], ['Y'])
    key = replace_end(key, ['A'], [''])
    return key1 + key

if __name__ == '__main__':
    names = ['Bishop', 'Carlson', 'Carr', 'Chapman', 'Franklin',
             'Greene', 'Harper', 'Jacobs', 'Larson', 'Lawrence',
             'Lawson', 'Louis, XVI', 'Lynch', 'Mackenzie', 'Matthews',
             'McCormack', 'McDaniel', 'McDonald', 'Mclaughlin', 'Morrison',
             "O'Banion", "O'Brien", 'Richards', 'Silva', 'Watkins',
             'Wheeler', 'Willis', 'brown, sr', 'browne, III', 'browne, IV',
             'knight', 'mitchell', "o'daniel"]
    for name in names:
        print('%15s: %s' % (name, nysiis(name)))
