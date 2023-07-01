use MONKEY-SEE-NO-EVAL;
sub demo($x) { say "  $x\t───► ", EVAL $x }

demo '5**3**2';      # show ** is right associative
demo '(5**3)**2';
demo '5**(3**2)';

demo '[**] 5,3,2';   # reduction form, show only final result
demo '[\**] 5,3,2';  # triangle reduction, show growing results

# Unicode postfix exponents are supported as well:

demo '(5³)²';
demo '5³²';
