import json


class EBNFParser:
    def __init__(self):
        self.src = ''
        self.ch = ''
        self.sdx = 0
        self.token = None
        self.err = False
        self.idents = []
        self.ididx = []
        self.productions = []
        self.extras = []
        self.results = ['pass', 'fail']

    def btoi(self, b):
        return 1 if b else 0

    def invalid(self, msg):
        self.err = True
        print(msg)
        self.sdx = len(self.src)  # set to eof
        return -1

    def skip_spaces(self):
        while self.sdx < len(self.src):
            self.ch = self.src[self.sdx]
            if self.ch not in ' \t\r\n':
                break
            self.sdx += 1

    def get_token(self):
        # Yields a single character token, one of {}()[]|=.;
        # or ["terminal",string] or ["ident", string] or -1.
        self.skip_spaces()
        if self.sdx >= len(self.src):
            self.token = {'value': -1, 'is_sequence': False}
            return

        tokstart = self.sdx
        if self.ch in '{}()[]|=.;':
            self.sdx += 1
            self.token = {'value': self.ch, 'is_sequence': False}
        elif self.ch in '"\'':
            closech = self.ch
            tokend = tokstart + 1
            while tokend < len(self.src) and self.src[tokend] != closech:
                tokend += 1
            if tokend >= len(self.src):
                self.token = {'value': self.invalid('no closing quote'), 'is_sequence': False}
            else:
                self.sdx = tokend + 1
                self.token = {
                    'value': ['terminal', self.src[tokstart + 1:tokend]],
                    'is_sequence': True
                }
        elif 'a' <= self.ch <= 'z':
            # To simplify things for the purposes of this task,
            # identifiers are strictly a-z only, not A-Z or 1-9.
            while self.sdx < len(self.src) and 'a' <= self.ch <= 'z':
                self.sdx += 1
                if self.sdx < len(self.src):
                    self.ch = self.src[self.sdx]
            self.token = {
                'value': ['ident', self.src[tokstart:self.sdx]],
                'is_sequence': True
            }
        else:
            self.token = {'value': self.invalid('invalid ebnf'), 'is_sequence': False}

    def match_token(self, expected_ch):
        if self.token['value'] != expected_ch:
            self.token = {
                'value': self.invalid(f'invalid ebnf ({expected_ch} expected)'),
                'is_sequence': False
            }
        else:
            self.get_token()

    def add_ident(self, ident):
        try:
            k = self.idents.index(ident)
        except ValueError:
            self.idents.append(ident)
            k = len(self.idents) - 1
            self.ididx.append(-1)
        return k

    def factor(self):
        if self.token['is_sequence']:
            t = self.token['value']
            if t[0] == 'ident':
                idx = self.add_ident(t[1])
                t.append(idx)
                self.token['value'] = t
            res = self.token['value']
            self.get_token()
        elif self.token['value'] == '[':
            self.get_token()
            res = ['optional', self.expression()]
            self.match_token(']')
        elif self.token['value'] == '(':
            self.get_token()
            res = self.expression()
            self.match_token(')')
        elif self.token['value'] == '{':
            self.get_token()
            res = ['repeat', self.expression()]
            self.match_token('}')
        else:
            raise ValueError('invalid token in factor() function')

        if isinstance(res, list) and len(res) == 1:
            return res[0]
        return res

    def term(self):
        res = [self.factor()]
        tokens = [-1, '|', '.', ';', ')', ']', '}']

        while True:
            if self.token['value'] in tokens:
                break
            res.append(self.factor())

        if len(res) == 1:
            return res[0]
        return res

    def expression(self):
        res = [self.term()]
        if self.token['value'] == '|':
            res = ['or', res[0]]
            while self.token['value'] == '|':
                self.get_token()
                res.append(self.term())

        if len(res) == 1:
            return res[0]
        return res

    def production(self):
        # Returns a token or -1; the real result is left in 'productions' etc,
        self.get_token()
        if self.token['value'] != '}':
            if self.token['value'] == -1:
                return self.invalid('invalid ebnf (missing closing })')
            if not self.token['is_sequence']:
                return -1

            t = self.token['value']
            if t[0] != 'ident':
                return -1

            ident = t[1]
            idx = self.add_ident(ident)
            self.get_token()
            self.match_token('=')
            if self.token['value'] == -1:
                return -1

            self.productions.append([ident, idx, self.expression()])
            self.ididx[idx] = len(self.productions) - 1

        return self.token['value']

    def parse(self, ebnf):
        # Returns +1 if ok, -1 if bad.
        print(f'parse:\n{ebnf} ===>')
        self.err = False
        self.src = ebnf
        self.sdx = 0
        self.idents = []
        self.ididx = []
        self.productions = []
        self.extras = []

        self.get_token()
        if self.token['is_sequence']:
            t = self.token['value']
            t[0] = 'title'
            self.extras.append(self.token['value'])
            self.get_token()

        if self.token['value'] != '{':
            return self.invalid('invalid ebnf (missing opening {)')

        while True:
            token_result = self.production()
            if token_result == '}' or token_result == -1:
                break

        self.get_token()
        if self.token['is_sequence']:
            t = self.token['value']
            t[0] = 'comment'
            self.extras.append(self.token['value'])
            self.get_token()

        if self.token['value'] != -1:
            return self.invalid('invalid ebnf (missing eof?)')

        if self.err:
            return -1

        k = -1
        for i in range(len(self.ididx)):
            if self.ididx[i] == -1:
                k = i
                break

        if k != -1:
            return self.invalid(f'invalid ebnf (undefined:{self.idents[k]})')

        self.pprint(self.productions, 'productions')
        self.pprint(self.idents, 'idents')
        self.pprint(self.ididx, 'ididx')
        self.pprint(self.extras, 'extras')
        return 1

    def pprint(self, ob, header):
        # Adjusts Python's normal printing to look more like Phix output.
        print(f'\n{header}:')
        pp = json.dumps(ob)
        pp = pp.replace('[', '{')
        pp = pp.replace(']', '}')
        pp = pp.replace(',', ', ')
        for i in range(len(self.idents)):
            pp = pp.replace(f'\\b{i}\\b', str(i))
        print(pp)

    def applies(self, rule):
        # The rules that applies() has to deal with are:
        # [factors] - if rule[0] is not string,
        # just apply one after the other recursively.
        # ["terminal", "a1"]       -- literal constants
        # ["or", <e1>, <e2>, ...}  -- (any) one of n
        # ["repeat", <e1>]         -- as per "{}" in ebnf
        # ["optional", <e1>]       -- as per "[]" in ebnf
        # ["ident", <name>, idx]   -- apply the sub-rule

        was_sdx = self.sdx  # in case of failure
        r1 = rule[0]

        if not isinstance(r1, str):
            for i in range(len(rule)):
                if not self.applies(rule[i]):
                    self.sdx = was_sdx
                    return False
        elif r1 == 'terminal':
            self.skip_spaces()
            r2 = rule[1]
            for i in range(len(r2)):
                if self.sdx >= len(self.src) or self.src[self.sdx] != r2[i]:
                    self.sdx = was_sdx
                    return False
                self.sdx += 1
        elif r1 == 'or':
            for i in range(1, len(rule)):
                if self.applies(rule[i]):
                    return True
            self.sdx = was_sdx
            return False
        elif r1 == 'repeat':
            while self.applies(rule[1]):
                # continue repeating
                pass
        elif r1 == 'optional':
            self.applies(rule[1])
        elif r1 == 'ident':
            i = rule[2]
            ii = self.ididx[i]
            if not self.applies(self.productions[ii][2]):
                self.sdx = was_sdx
                return False
        else:
            raise ValueError('invalid rule in applies() function')

        return True

    def check_valid(self, test):
        self.src = test
        self.sdx = 0
        res = self.applies(self.productions[0][2])
        self.skip_spaces()
        if self.sdx < len(self.src):
            res = False
        print(f'"{test}", {self.results[1 - self.btoi(res)]}')


# Main execution
if __name__ == "__main__":
    parser = EBNFParser()

    ebnfs = [
        '"a" {\n' +
        '    a = "a1" ( "a2" | "a3" ) { "a4" } [ "a5" ] "a6" ;\n' +
        '} "z" ',

        '{\n' +
        '    expr = term { plus term } .\n' +
        '    term = factor { times factor } .\n' +
        '    factor = number | \'(\' expr \')\' .\n' +
        ' \n' +
        '    plus = "+" | "-" .\n' +
        '    times = "*" | "/" .\n' +
        ' \n' +
        '    number = digit { digit } .\n' +
        '    digit = "0" | "1" | "2" | "3" | "4" | "5" | "6" | "7" | "8" | "9" .\n' +
        '}',

        'a = "1"',
        '{ a = "1" ;',
        '{ hello world = "1"; }',
        '{ foo = bar . }'
    ]

    tests = [
        [
            'a1a3a4a4a5a6',
            'a1 a2a6',
            'a1 a3 a4 a6',
            'a1 a4 a5 a6',
            'a1 a2 a4 a5 a5 a6',
            'a1 a2 a4 a5 a6 a7',
            'your ad here'
        ],
        [
            '2',
            '2*3 + 4/23 - 7',
            '(3 + 4) * 6-2+(4*(4))',
            '-2',
            '3 +',
            '(4 + 3'
        ]
    ]

    for i in range(len(ebnfs)):
        if parser.parse(ebnfs[i]) == 1:
            print('\ntests:')
            if i < len(tests):
                for test in tests[i]:
                    parser.check_valid(test)
        print('')
