# emit a stream of Gaussian primes with real and imaginary parts within the given radius
def GPrimes($Radius):
  def check: abs | isPrime and ((. - 3) % 4 == 0);
  ($Radius | norm) as $R2
  | range(-$Radius; $Radius + 1) as $r
  | range(-$Radius; $Radius + 1) as $i
  | [$r, $i]
  | norm as $norm
  | select( $norm < $R2 )
  | if   $i == 0  then select($r|check)
    elif $r == 0  then select($i|check)
    else               select($norm|isPrime)
    end ;

def plot($Radius):
  "# X Y",
  (GPrimes($Radius) | "\(first) \(last)");

