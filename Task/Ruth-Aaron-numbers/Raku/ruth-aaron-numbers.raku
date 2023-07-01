use Prime::Factor;

my @pf  = lazy (^∞).hyper(:1000batch).map: *.&prime-factors.sum;
my @upf = lazy (^∞).hyper(:1000batch).map: *.&prime-factors.unique.sum;

# Task: < 1 second
put "First 30 Ruth-Aaron numbers (Factors):\n" ~
(1..∞).grep( { @pf[$_] == @pf[$_ + 1] } )[^30];

put "\nFirst 30 Ruth-Aaron numbers (Divisors):\n" ~
(1..∞).grep( { @upf[$_] == @upf[$_ + 1] } )[^30];

# Stretch: ~ 5 seconds
put "\nFirst Ruth-Aaron triple (Factors):\n" ~
(1..∞).first: { @pf[$_] == @pf[$_ + 1] == @pf[$_ + 2] }

# Really, really, _really_ slow. 186(!) minutes... but with no cheating or "leg up".
put "\nFirst Ruth-Aaron triple (Divisors):\n" ~
(1..∞).first: { @upf[$_] == @upf[$_ + 1] == @upf[$_ + 2] }
