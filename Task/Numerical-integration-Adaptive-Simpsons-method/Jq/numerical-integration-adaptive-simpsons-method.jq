# Integrate f from $a to $b using the adaptive Simpson's rule (ASR)
# with max error of $eps.
def quadASR(f; $a; $b; $eps):

  # Emit [$m, $fm, $sim]
  def quadSimpsonMem($a; $fa; $b; $fb):
    (($a + $b) / 2) as $m
    | ($m|f) as $fm
    | ($fa + 4*$fm + $fb) as $x
    | [$m, $fm, ((($b - $a) | length) / 6) * $x];

  # Efficient recursive implementation of adaptive Simpson's rule.
  def quadASR:
    . as [$a, $fa, $b, $fb, $eps, $whole, $m, $fm]
    # Function values at the start, middle, end of the intervals are retained.
    | quadSimpsonMem($a; $fa; $m; $fm) as [$lm, $flm, $left]
    | quadSimpsonMem($m; $fm; $b; $fb) as [$rm, $frm, $right]
    | ($left + $right - $whole) as $delta
    | if ($delta|length) < ($eps * 15)
      then  $left + $right + ($delta/15)
      else ([$a, $fa, $m, $fm, $eps/2, $left, $lm, $flm] | quadASR) +
           ([$m, $fm, $b, $fb, $eps/2, $right, $rm, $frm] | quadASR)
      end;

    ($a|f) as $fa
    | ($b|f) as $fb
    | quadSimpsonMem($a; $fa; $b; $fb) as [$m, $fm, $whole]
    | [$a, $fa, $b, $fb, $eps, $whole, $m, $fm] | quadASR ;

def sinx($a;$b):
  quadASR(sin ; $a; $b; 1e-09);

"Simpson's integration of sin from 0 to 1 = \(sinx(0;1))"
