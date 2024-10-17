use std::str::FromStr;

#[derive(Clone, Debug)]
pub struct Rule {
    pub pat: String,
    pub rep: String,
    pub terminal: bool,
}

impl Rule {
    pub fn new(pat: String, rep: String, terminal: bool) -> Self {
        Self { pat, rep, terminal }
    }

    pub fn applicable_range(&self, input: impl AsRef<str>) -> Option<std::ops::Range<usize>> {
        input
            .as_ref()
            .match_indices(&self.pat)
            .next()
            .map(|(start, slice)| start..start + slice.len())
    }

    pub fn apply(&self, s: &mut String) -> bool {
        self.applicable_range(s.as_str()).map_or(false, |range| {
            s.replace_range(range, &self.rep);
            true
        })
    }
}

impl FromStr for Rule {
    type Err = String;

    fn from_str(s: &str) -> Result<Self, Self::Err> {
        let mut split = s.splitn(2, " -> ");
        let pat = split.next().ok_or_else(|| s.to_string())?;
        let rep = split.next().ok_or_else(|| s.to_string())?;

        let pat = pat.to_string();
        if rep.starts_with('.') {
            Ok(Self::new(pat, rep[1..].to_string(), true))
        } else {
            Ok(Self::new(pat, rep.to_string(), false))
        }
    }
}

#[derive(Clone, Debug)]
pub struct Rules {
    rules: Vec<Rule>,
}

impl Rules {
    pub fn new(rules: Vec<Rule>) -> Self {
        Self { rules }
    }

    pub fn apply(&self, s: &mut String) -> Option<&Rule> {
        self.rules
            .iter()
            .find(|rule| rule.apply(s))
    }

    pub fn execute(&self, mut buffer: String) -> String {
        while let Some(rule) = self.apply(&mut buffer) {
            if rule.terminal {
                break;
            }
        }

        buffer
    }
}

impl FromStr for Rules {
    type Err = String;

    fn from_str(s: &str) -> Result<Self, Self::Err> {
        let mut rules = Vec::new();

        for line in s.lines().filter(|line| !line.starts_with('#')) {
            rules.push(line.parse::<Rule>()?);
        }

        Ok(Rules::new(rules))
    }
}

#[cfg(test)]
mod tests {

    use super::Rules;

    #[test]
    fn case_01() -> Result<(), String> {
        let input = "I bought a B of As from T S.";
        let rules = "\
# This rules file is extracted from Wikipedia:
# http://en.wikipedia.org/wiki/Markov_Algorithm
A -> apple
B -> bag
S -> shop
T -> the
the shop -> my brother
a never used -> .terminating rule";

        assert_eq!(
            rules.parse::<Rules>()?.execute(input.to_string()),
            "I bought a bag of apples from my brother."
        );

        Ok(())
    }

    #[test]
    fn case_02() -> Result<(), String> {
        let input = "I bought a B of As from T S.";
        let rules = "\
# Slightly modified from the rules on Wikipedia
A -> apple
B -> bag
S -> .shop
T -> the
the shop -> my brother
a never used -> .terminating rule";

        assert_eq!(
            rules.parse::<Rules>()?.execute(input.to_string()),
            "I bought a bag of apples from T shop."
        );

        Ok(())
    }

    #[test]
    fn case_03() -> Result<(), String> {
        let input = "I bought a B of As W my Bgage from T S.";
        let rules = "\
# BNF Syntax testing rules
A -> apple
WWWW -> with
Bgage -> ->.*
B -> bag
->.* -> money
W -> WW
S -> .shop
T -> the
the shop -> my brother
a never used -> .terminating rule";

        assert_eq!(
            rules.parse::<Rules>()?.execute(input.to_string()),
            "I bought a bag of apples with my money from T shop."
        );

        Ok(())
    }

    #[test]
    fn case_04() -> Result<(), String> {
        let input = "_1111*11111_";
        let rules = "\
### Unary Multiplication Engine, for testing Markov Algorithm implementations
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
_+_ -> ";

        assert_eq!(
            rules.parse::<Rules>()?.execute(input.to_string()),
            "11111111111111111111"
        );

        Ok(())
    }

    #[test]
    fn case_05() -> Result<(), String> {
        let input = "000000A000000";
        let rules = "\
# Turing machine: three-state busy beaver
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
1C1 -> H11";

        assert_eq!(
            rules.parse::<Rules>()?.execute(input.to_string()),
            "00011H1111000"
        );

        Ok(())
    }
}
