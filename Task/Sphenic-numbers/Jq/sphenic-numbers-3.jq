# Output: an array of sphenic numbers
def sphenic($limit):
  def primes: (($limit/6)|floor) | primeSieve | map(select(.));

  primes
  | . as $primes
  | length as $pc
  | ($limit|cubrt|floor) as $limit2 # first prime can't be more than this
  | last(
      label $out
      | foreach (range(0; $pc-2), null) as $i (null;
        if $i == null or ($primes[$i] > $limit2) then break $out
        else label $jout
        | foreach range($i+1; $pc-1) as $j (.;
            ($primes[$i] * $primes[$j]) as $prod
            | if ($prod * $primes[$j + 1] >= $limit) then break $jout
              else label $kout
            | foreach range($j+1; $pc) as $k (.;
                  ($prod * $primes[$k]) as $res
                  | if $res >= $limit then break $kout
                  else . + [$res]
                  end)
              end)
        end )) ;

# Input: sphenic
def triplets:
  . as $sphenic
  | reduce range(0; $sphenic|length-2) as $i (null;
      $sphenic[$i] as $s
      | if $sphenic[$i+1] == $s + 1 and $sphenic[$i+2] == $s + 2
        then . + [[$s, $s + 1, $s + 2]]
        else .
        end );

def task($limit):
  (sphenic($limit)|sort) as $sphenic
  | "Sphenic numbers less than 1,000:",
    ([select_while($sphenic[];  . < 1000)] | pp(10;3)),
    "Sphenic triplets less than 10,000:",
    ([select_while($sphenic|triplets[] ; .[2] < 10000 )] | pp(3;0)),
    "\nThere are \($sphenic|length) sphenic numbers less than 1,000,000.",
    "\nThere are \($sphenic|triplets|length) sphenic triplets less than 1,000,000.",
    ($sphenic[199999] as $s
     | "The 200,000th sphenic number is \($s).",
       "The 5,000th sphenic triplet is \($sphenic|triplets[4999])") ;

task(1000000)
