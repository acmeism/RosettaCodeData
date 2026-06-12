# whilst/2 is like while/2 but emits the final term rather than the first one
def whilst(cond; update):
     def _whilst:
         if cond then update | (., _whilst) else empty end;
     _whilst;

def digitSum:
  def add(s): reduce s as $_ (0; . + $_);
  add(tostring | explode[] | . - 48);

def expDigitSums(numNeeded; minWays; maxPower):
  {i: 1, c: 0}
  | whilst(.c < numNeeded;
      .i += 1
      | .n = .i
      | reduce range(2; 1+ maxPower) as $p (.res = [];
          .n *= .i
          | if .i == (.n|digitSum)
            then .res += ["\(.i)^\($p)"]
            end)
      | if .res|length >= minWays
        then .c += 1
        end )
  | select(.res|length >= minWays)
  | .res | join(", ");

"First twenty-five integers that are equal to the digital sum of that integer raised to some power:",
expDigitSums(25; 1; 100),

"\nFirst thirty that satisfy that condition in three or more ways:",
expDigitSums(30; 3; 500)
