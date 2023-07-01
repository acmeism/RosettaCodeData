def lpad($len): tostring | ($len - length) as $l | (" " * $l)[:$l] +.;

def task($sievesize):
  {compSums:[],
   primeSums:[],
   csum:0,
   psum:0 }
  | reduce range(2; $sievesize) as $i (.;
      if $i|is_prime
      then .psum += $i
      | .primeSums += [.psum]
      else .csum += $i
      | .compSums += [ .csum ]
      end)
  | range(0; .primeSums|length) as $i
  | .primeSums[$i] as $ps
  | (.compSums | index( $ps )) as $ix
  | select($ix >= 0)
  | "\($ps|lpad(21)) - \($i+1|lpad(21)) prime sum, \($ix+1|lpad(12)) composite sum"
;

task(1E5)
