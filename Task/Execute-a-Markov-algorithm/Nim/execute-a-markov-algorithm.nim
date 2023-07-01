import strutils, strscans

type Rule = object
  pattern: string       # Input pattern.
  replacement: string   # Replacement string (may be empty).
  terminating: bool     # "true" if terminating rule.

#---------------------------------------------------------------------------------------------------

func parse(rules: string): seq[Rule] =
  ## Parse a rule set to build a sequence of rules.

  var linecount = 0
  for line in rules.splitLines():

    inc linecount
    if line.startsWith('#'): continue
    if line.strip.len == 0: continue

    # Scan the line.
    var pat, rep: string
    var terminating = false
    if not line.scanf("$+ -> $*", pat, rep):
      raise newException(ValueError, "Invalid rule at line " & $linecount)

    if rep.startsWith('.'):
      # Terminating rule.
      rep = rep[1..^1]
      terminating = true

    result.add(Rule(pattern: pat, replacement: rep, terminating: terminating))

#---------------------------------------------------------------------------------------------------

func apply(text: string; rules: seq[Rule]): string =
  ## Apply a set of rules to a text and return the result.

  result = text
  var changed = true

  while changed:
    changed = false
    # Try to apply the rules in sequence.
    for rule in rules:
      if result.find(rule.pattern) >= 0:
        # Found a rule to apply.
        result = result.replace(rule.pattern, rule.replacement)
        if rule.terminating: return
        changed = true
        break

#———————————————————————————————————————————————————————————————————————————————————————————————————

const SampleTexts = ["I bought a B of As from T S.",
                     "I bought a B of As from T S.",
                     "I bought a B of As W my Bgage from T S.",
                     "_1111*11111_",
                     "000000A000000"]

const Rulesets = [

#................................................

"""# This rules file is extracted from Wikipedia:
# http://en.wikipedia.org/wiki/Markov_Algorithm
A -> apple
B -> bag
S -> shop
T -> the
the shop -> my brother
a never used -> .terminating rule""",

#................................................

"""# Slightly modified from the rules on Wikipedia
A -> apple
B -> bag
S -> .shop
T -> the
the shop -> my brother
a never used -> .terminating rule""",

#................................................

"""# BNF Syntax testing rules
A -> apple
WWWW -> with
Bgage -> ->.*
B -> bag
->.* -> money
W -> WW
S -> .shop
T -> the
the shop -> my brother
a never used -> .terminating rule""",

#................................................

"""### Unary Multiplication Engine, for testing Markov Algorithm implementations
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
_+_ -> """,

#................................................

"""# Turing machine: three-state busy beaver
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
1C1 -> H11"""

]

for n, ruleset in RuleSets:
  let rules = ruleset.parse()
  echo SampleTexts[n].apply(rules)
