def K: 7800000000;   # approx world population
def n0: 27;          # number of cases at day 0

def y: [
    27, 27, 27, 44, 44, 59, 59, 59, 59, 59, 59, 59, 59, 60, 60,
    61, 61, 66, 83, 219, 239, 392, 534, 631, 897, 1350, 2023,
    2820, 4587, 6067, 7823, 9826, 11946, 14554, 17372, 20615,
    24522, 28273, 31491, 34933, 37552, 40540, 43105, 45177,
    60328, 64543, 67103, 69265, 71332, 73327, 75191, 75723,
    76719, 77804, 78812, 79339, 80132, 80995, 82101, 83365,
    85203, 87024, 89068, 90664, 93077, 95316, 98172, 102133,
    105824, 109695, 114232, 118610, 125497, 133852, 143227,
    151367, 167418, 180096, 194836, 213150, 242364, 271106,
    305117, 338133, 377918, 416845, 468049, 527767, 591704,
    656866, 715353, 777796, 851308, 928436, 1000249, 1082054,
    1174652
];

def f:
  . as $r
  | reduce range(0; y|length) as $i (0;
        (($r*$i)|exp) as $eri
        | ((n0*$eri)/(1+n0*($eri-1)/K) - y[$i]) as $dst
        | . + $dst * $dst);

def solve(f; $guess; $epsilon):
  { f0:    ($guess|f),
    delta: $guess,
    factor: 2,
    $guess}
  # double until f0 best, then halve until delta <= epsilon
  | until(.delta <= $epsilon;
      .nf = ((.guess - .delta)|f)
      | if .nf < .f0
      then .f0 = .nf
      |  .guess = .guess - .delta
      else .nf = ((.guess + .delta)|f)
      | if .nf < .f0
        then .f0 = .nf
        | .guess = .guess + .delta
        else .factor = 0.5
        end
      end
      | .delta = .delta * .factor )
  | .guess;

((solve(f; 0.5; 0) * 1e10)|round / 1e10 ) as $r
| ((((12 * $r)|exp) * 1e8)|round / 1e8) as $R0
| "r = \($r), R0 = \($R0)"
