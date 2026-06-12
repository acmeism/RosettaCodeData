include "complex"; # a reminder

def dft:
  . as $x
  | length as $N
  | reduce range (0; $N) as $k ([]; # y
      .[$k] = [0,0] # Complex.zero
      | reduce range( 0; $N) as $n (.;
          ([[0, -1], [2,0], [pi,0], $k, $n, invert($N) ] | multiply) as $t
          | .[$k] = plus(.[$k]; multiply($x[$n]; exp($t))) ) ) ;

# Input: an array of Complex
def idft:
  . as $y
  | length as $N
  | reduce range(0; $N) as $n ([];
      .[$n] = [0,0]
      | reduce range(0; $N) as $k (.;
          ( [ 2, pi, [0,1], $k, $n, invert($N)] | multiply) as $t
          | .[$n] = plus(.[$n];  multiply($y[$k]; exp($t))) )
        | .[$n] = divide(.[$n]; $N) );


def task:
  def abs: if . < 0 then -. else . end;
  # round, and remove very small imaginary values altogether
  def tidy:
    (.[0] | round) as $round
    | if (.[0]| (. - $round) | abs < 1e-14) then .[0] = $round else . end
    | if .[1]|abs < 1e-14 then .[0] else . end;

  [2, 3, 5, 7, 11] as $x
  | "Original sequence: \($x)",
    (reduce range(0; $x|length) as $i ( []; .[$i] = [$x[$i], 0])
     | dft
     | "\nAfter applying the Discrete Fourier Transform:",
       .,
       "\nAfter applying the Inverse Discrete Fourier Transform to this value: \(
          idft | map(tidy))" )
     ;

task
