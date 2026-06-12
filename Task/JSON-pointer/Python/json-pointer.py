""" rosettacode.org/wiki/JSON_pointer """

from functools import reduce


class JSONPointer:
    """ datatracker.ietf.org/doc/html/rfc6901 """

    def __init__(self, pstring):
        """ create a JSON ponter from a string """
        self.tokens = parse(pstring)

    def resolve(self, data):
        """ use the pointer on an object """
        return reduce(get_item, self.tokens, data)

    def encode(self):
        """ output pointer in string form """
        ret = ''
        for tok in self.tokens:
            ret = ret + '/' + tok.replace('~', '~0').replace('/', '~1')
        return ret

    def to_string(self):
        """ output pointer in string form """
        return self.encode()


def parse(pst):
    """ tokenize a string for use as JSON pointer """
    if pst == '':
        return []
    if pst[0] != '/':
        raise SyntaxError('Non-empty JSON pointers must begin with /')
    return [a.replace('~1', '/').replace('~0', '~') for a in pst.split('/')][1:]


def get_item(obj, token):
    """
    NOTE:
        - string primitives 'have own' indices and `length`.
        - Arrays have a `length` property.
        - A property might exist with the value `undefined`.
        - obj[1] is equivalent to obj['1'].
    """
    if isinstance(obj, list) and isinstance(token, str):
        return obj[int(token)]
    return obj[token]


if __name__ == '__main__':

    DOC = {
        'wiki': {
            'links': [
                'https://rosettacode.org/wiki/Rosetta_Code',
                'https://discord.com/channels/1011262808001880065',
            ],
        },
        '': 'Rosetta',
        ' ': 'Code',
        'g/h': 'chrestomathy',
        'i~j': 'site',
        'abc': ['is', 'a'],
        'def': {'': 'programming'},
    }

    EXAMPLES = [
        '',
        '/',
        '/ ',
        '/abc',
        '/def/',
        '/g~1h',
        '/i~0j',
        '/wiki/links/0',
        '/wiki/links/1',
        '/wiki/links/2',
        '/wiki/name',
        '/no/such/thing',
        'bad/pointer',
    ]

    for exa in EXAMPLES:
        try:
            pointer = JSONPointer(exa)
            result = pointer.resolve(DOC)
            print(f'"{exa}" -> "{result}"')
        except (SyntaxError, IndexError, KeyError) as error:
            print(f'Error: {exa} does not exist: {error}')
