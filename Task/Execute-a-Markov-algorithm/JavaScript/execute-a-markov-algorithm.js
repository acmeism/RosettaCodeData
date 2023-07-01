/**
 * Take a ruleset and return a function which takes a string to which the rules
 * should be applied.
 * @param {string} ruleSet
 * @returns {function(string): string}
 */
const markov = ruleSet => {

  /**
   * Split a string at an index
   * @param {string} s The string to split
   * @param {number} i The index number where to split.
   * @returns {Array<string>}
   */
  const splitAt = (s, i) => [s.slice(0, i), s.slice(i)];

  /**
   * Strip a leading number of chars from a string.
   * @param {string} s The string to strip the chars from
   * @param {string} strip A string who's length will determine the number of
   *    chars to strip.
   * @returns {string}
   */
  const stripLeading = (s, strip) => s.split('')
      .filter((e, i) => i >= strip.length).join('');

  /**
   * Replace the substring in the string.
   * @param {string} s The string to replace the substring in
   * @param {string} find The sub-string to find
   * @param {string} rep The replacement string
   * @returns {string}
   */
  const replace = (s, find, rep) => {
    let result = s;
    if (s.indexOf(find) >= 0) {
      const a = splitAt(s, s.indexOf(find));
      result = [a[0], rep, stripLeading(a[1], find)].join('');
    }
    return result;
  };

  /**
   * Convert a ruleset string into a map
   * @param {string} ruleset
   * @returns {Map}
   */
  const makeRuleMap = ruleset => ruleset.split('\n')
      .filter(e => !e.startsWith('#'))
      .map(e => e.split(' -> '))
      .reduce((p,c) => p.set(c[0], c[1]), new Map());

  /**
   * Recursively apply the ruleset to the string.
   * @param {Map} rules The rules to apply
   * @param {string} s The string to apply the rules to
   * @returns {string}
   */
  const parse = (rules, s) => {
    const o = s;
    for (const [k, v] of rules.entries()) {
      if (v.startsWith('.')) {
        s = replace(s, k, stripLeading(v, '.'));
        break;
      } else {
        s = replace(s, k, v);
        if (s !== o) { break; }
      }
    }
    return o === s ? s : parse(rules, s);
  };

  const ruleMap = makeRuleMap(ruleSet);

  return str => parse(ruleMap, str)
};


const ruleset1 = `# This rules file is extracted from Wikipedia:
# http://en.wikipedia.org/wiki/Markov_Algorithm
A -> apple
B -> bag
S -> shop
T -> the
the shop -> my brother
a never used -> .terminating rule`;

const ruleset2 = `# Slightly modified from the rules on Wikipedia
A -> apple
B -> bag
S -> .shop
T -> the
the shop -> my brother
a never used -> .terminating rule`;

const ruleset3 = `# BNF Syntax testing rules
A -> apple
WWWW -> with
Bgage -> ->.*
B -> bag
->.* -> money
W -> WW
S -> .shop
T -> the
the shop -> my brother
a never used -> .terminating rule`;

const ruleset4 = `### Unary Multiplication Engine, for testing Markov Algorithm implementations
### By Donal Fellows.
# Unary addition engine
_+1 -> _1+
1+1 -> 11+
# Pass for converting from the splitting of multiplication into ordinary
# addition
1! -> !1
,! -> !+
_! -> _
# Unary multiplication by duplicating left side, right side times
1*1 -> x,@y
1x -> xX
X, -> 1,1
X1 -> 1X
_x -> _X
,x -> ,X
y1 -> 1y
y_ -> _
# Next phase of applying
1@1 -> x,@y
1@_ -> @_
,@_ -> !_
++ -> +
# Termination cleanup for addition
_1 -> 1
1+_ -> 1
_+_ -> `;

const ruleset5 = `# Turing machine: three-state busy beaver
#
# state A, symbol 0 => write 1, move right, new state B
A0 -> 1B
# state A, symbol 1 => write 1, move left, new state C
0A1 -> C01
1A1 -> C11
# state B, symbol 0 => write 1, move left, new state A
0B0 -> A01
1B0 -> A11
# state B, symbol 1 => write 1, move right, new state B
B1 -> 1B
# state C, symbol 0 => write 1, move left, new state B
0C0 -> B01
1C0 -> B11
# state C, symbol 1 => write 1, move left, halt
0C1 -> H01
1C1 -> H11`;

console.log(markov(ruleset1)('I bought a B of As from T S.'));
console.log(markov(ruleset2)('I bought a B of As from T S.'));
console.log(markov(ruleset3)('I bought a B of As W my Bgage from T S.'));
console.log(markov(ruleset4)('_1111*11111_'));
console.log(markov(ruleset5)('000000A000000'));
