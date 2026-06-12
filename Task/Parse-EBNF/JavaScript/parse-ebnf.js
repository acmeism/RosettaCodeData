class EBNFParser {
    constructor() {
        this.src = '';
        this.ch = '';
        this.sdx = 0;
        this.token = null;
        this.err = false;
        this.idents = [];
        this.ididx = [];
        this.productions = [];
        this.extras = [];
        this.results = ['pass', 'fail'];
    }

    btoi(b) {
        return b ? 1 : 0;
    }

    invalid(msg) {
        this.err = true;
        console.log(msg);
        this.sdx = this.src.length; // set to eof
        return -1;
    }

    skipSpaces() {
        while (this.sdx < this.src.length) {
            this.ch = this.src.charAt(this.sdx);
            if (' \t\r\n'.indexOf(this.ch) === -1) {
                break;
            }
            this.sdx++;
        }
    }

    getToken() {
        // Yields a single character token, one of {}()[]|=.;
        // or ["terminal",string] or ["ident", string] or -1.
        this.skipSpaces();
        if (this.sdx >= this.src.length) {
            this.token = { value: -1, isSequence: false };
            return;
        }
        const tokstart = this.sdx;
        if ('{}()[]|=.;'.indexOf(this.ch) >= 0) {
            this.sdx++;
            this.token = { value: this.ch, isSequence: false };
        } else if (this.ch === '"' || this.ch === "'") {
            const closech = this.ch;
            let tokend = tokstart + 1;
            while (tokend < this.src.length && this.src.charAt(tokend) !== closech) {
                tokend++;
            }
            if (tokend >= this.src.length) {
                this.token = { value: this.invalid('no closing quote'), isSequence: false };
            } else {
                this.sdx = tokend + 1;
                this.token = {
                    value: ['terminal', this.src.substring(tokstart + 1, tokend)],
                    isSequence: true
                };
            }
        } else if (this.ch >= 'a' && this.ch <= 'z') {
            // To simplify things for the purposes of this task,
            // identifiers are strictly a-z only, not A-Z or 1-9.
            while (this.sdx < this.src.length && this.ch >= 'a' && this.ch <= 'z') {
                this.sdx++;
                if (this.sdx < this.src.length) {
                    this.ch = this.src.charAt(this.sdx);
                }
            }
            this.token = {
                value: ['ident', this.src.substring(tokstart, this.sdx)],
                isSequence: true
            };
        } else {
            this.token = { value: this.invalid('invalid ebnf'), isSequence: false };
        }
    }

    matchToken(expectedCh) {
        if (this.token.value !== expectedCh) {
            this.token = {
                value: this.invalid(`invalid ebnf (${expectedCh} expected)`),
                isSequence: false
            };
        } else {
            this.getToken();
        }
    }

    addIdent(ident) {
        let k = this.idents.indexOf(ident);
        if (k === -1) {
            this.idents.push(ident);
            k = this.idents.length - 1;
            this.ididx.push(-1);
        }
        return k;
    }

    factor() {
        let res;
        if (this.token.isSequence) {
            const t = this.token.value;
            if (t[0] === 'ident') {
                const idx = this.addIdent(t[1]);
                t.push(idx);
                this.token.value = t;
            }
            res = this.token.value;
            this.getToken();
        } else if (this.token.value === '[') {
            this.getToken();
            res = ['optional', this.expression()];
            this.matchToken(']');
        } else if (this.token.value === '(') {
            this.getToken();
            res = this.expression();
            this.matchToken(')');
        } else if (this.token.value === '{') {
            this.getToken();
            res = ['repeat', this.expression()];
            this.matchToken('}');
        } else {
            throw new Error('invalid token in factor() function');
        }
        if (Array.isArray(res) && res.length === 1) {
            return res[0];
        }
        return res;
    }

    term() {
        const res = [this.factor()];
        const tokens = [-1, '|', '.', ';', ')', ']', '}'];

        while (true) {
            if (tokens.includes(this.token.value)) {
                break;
            }
            res.push(this.factor());
        }

        if (res.length === 1) {
            return res[0];
        }
        return res;
    }

    expression() {
        let res = [this.term()];
        if (this.token.value === '|') {
            res = ['or', res[0]];
            while (this.token.value === '|') {
                this.getToken();
                res.push(this.term());
            }
        }
        if (res.length === 1) {
            return res[0];
        }
        return res;
    }

    production() {
        // Returns a token or -1; the real result is left in 'productions' etc,
        this.getToken();
        if (this.token.value !== '}') {
            if (this.token.value === -1) {
                return this.invalid('invalid ebnf (missing closing })');
            }
            if (!this.token.isSequence) {
                return -1;
            }
            const t = this.token.value;
            if (t[0] !== 'ident') {
                return -1;
            }
            const ident = t[1];
            const idx = this.addIdent(ident);
            this.getToken();
            this.matchToken('=');
            if (this.token.value === -1) {
                return -1;
            }
            this.productions.push([ident, idx, this.expression()]);
            this.ididx[idx] = this.productions.length - 1;
        }
        return this.token.value;
    }

    parse(ebnf) {
        // Returns +1 if ok, -1 if bad.
        console.log(`parse:\n${ebnf} ===>`);
        this.err = false;
        this.src = ebnf;
        this.sdx = 0;
        this.idents = [];
        this.ididx = [];
        this.productions = [];
        this.extras = [];

        this.getToken();
        if (this.token.isSequence) {
            const t = this.token.value;
            t[0] = 'title';
            this.extras.push(this.token.value);
            this.getToken();
        }
        if (this.token.value !== '{') {
            return this.invalid('invalid ebnf (missing opening {)');
        }

        while (true) {
            const tokenResult = this.production();
            if (tokenResult === '}' || tokenResult === -1) {
                break;
            }
        }

        this.getToken();
        if (this.token.isSequence) {
            const t = this.token.value;
            t[0] = 'comment';
            this.extras.push(this.token.value);
            this.getToken();
        }
        if (this.token.value !== -1) {
            return this.invalid('invalid ebnf (missing eof?)');
        }
        if (this.err) {
            return -1;
        }

        let k = -1;
        for (let i = 0; i < this.ididx.length; i++) {
            if (this.ididx[i] === -1) {
                k = i;
                break;
            }
        }
        if (k !== -1) {
            return this.invalid(`invalid ebnf (undefined:${this.idents[k]})`);
        }

        this.pprint(this.productions, 'productions');
        this.pprint(this.idents, 'idents');
        this.pprint(this.ididx, 'ididx');
        this.pprint(this.extras, 'extras');
        return 1;
    }

    // Adjusts JavaScript's normal printing to look more like Phix output.
    pprint(ob, header) {
        console.log(`\n${header}:`);
        let pp = JSON.stringify(ob);
        pp = pp.replace(/\[/g, '{');
        pp = pp.replace(/\]/g, '}');
        pp = pp.replace(/,/g, ', ');
        for (let i = 0; i < this.idents.length; i++) {
            pp = pp.replace(new RegExp(`\\b${i}\\b`, 'g'), String(i));
        }
        console.log(pp);
    }

    // The rules that applies() has to deal with are:
    // [factors] - if rule[0] is not string,
    // just apply one after the other recursively.
    // ["terminal", "a1"]       -- literal constants
    // ["or", <e1>, <e2>, ...}  -- (any) one of n
    // ["repeat", <e1>]         -- as per "{}" in ebnf
    // ["optional", <e1>]       -- as per "[]" in ebnf
    // ["ident", <name>, idx]   -- apply the sub-rule

    applies(rule) {
        const wasSdx = this.sdx; // in case of failure
        const r1 = rule[0];

        if (typeof r1 !== 'string') {
            for (let i = 0; i < rule.length; i++) {
                if (!this.applies(rule[i])) {
                    this.sdx = wasSdx;
                    return false;
                }
            }
        } else if (r1 === 'terminal') {
            this.skipSpaces();
            const r2 = rule[1];
            for (let i = 0; i < r2.length; i++) {
                if (this.sdx >= this.src.length || this.src.charAt(this.sdx) !== r2.charAt(i)) {
                    this.sdx = wasSdx;
                    return false;
                }
                this.sdx++;
            }
        } else if (r1 === 'or') {
            for (let i = 1; i < rule.length; i++) {
                if (this.applies(rule[i])) {
                    return true;
                }
            }
            this.sdx = wasSdx;
            return false;
        } else if (r1 === 'repeat') {
            while (this.applies(rule[1])) {
                // continue repeating
            }
        } else if (r1 === 'optional') {
            this.applies(rule[1]);
        } else if (r1 === 'ident') {
            const i = rule[2];
            const ii = this.ididx[i];
            if (!this.applies(this.productions[ii][2])) {
                this.sdx = wasSdx;
                return false;
            }
        } else {
            throw new Error('invalid rule in applies() function');
        }
        return true;
    }

    checkValid(test) {
        this.src = test;
        this.sdx = 0;
        let res = this.applies(this.productions[0][2]);
        this.skipSpaces();
        if (this.sdx < this.src.length) {
            res = false;
        }
        console.log(`"${test}", ${this.results[1 - this.btoi(res)]}`);
    }
}

// Main execution
const parser = new EBNFParser();

const ebnfs = [
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
];

const tests = [
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
];

for (let i = 0; i < ebnfs.length; i++) {
    if (parser.parse(ebnfs[i]) === 1) {
        console.log('\ntests:');
        if (i < tests.length) {
            for (const test of tests[i]) {
                parser.checkValid(test);
            }
        }
    }
    console.log('');
}
