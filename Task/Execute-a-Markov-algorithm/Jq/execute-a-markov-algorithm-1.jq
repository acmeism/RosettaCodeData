# Output: the input string with all its regex-special characters suitably escaped
def deregex:
  reduce ("\\\\", "\\*", "\\^", "\\?", "\\+", "\\.", "\\!", "\\{", "\\}", "\\[", "\\]", "\\$", "\\|",
          "\\(", "\\)" ) as $c
    (.; gsub( $c; $c));

# line-break
def lb: "\n";

def split2($s):
  index($s) as $ix
  | if $ix then [ .[:$ix], .[$ix + ($s|length):]] else null end;

def trim: sub("^ *";"") | sub(" *$";"");

# rulesets are assumed to be separated by a blank line
# input: a string
def readRules:
  trim | split("\(lb)\(lb)") | map(split(lb)) ;

# tests are assumed to be on consecutive lines via `inputs`
# Output: an array
def readTests: [inputs | trim | select(length>0) ];

def rules:  $markov_rules | readRules;

def tests:  readTests;
