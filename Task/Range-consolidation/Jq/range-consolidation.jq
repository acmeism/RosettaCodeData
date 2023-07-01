def normalize: map(sort) | sort;

def consolidate:
  normalize
  | length as $length
  | reduce range(0; $length) as $i (.;
      .[$i] as $r1
      | if $r1 != []
        then reduce range($i+1; $length) as $j (.;
               .[$j] as $r2
               | if $r2 != [] and ($r1[-1] >= $r2[0])     # intersect?
                 then .[$i] = [$r1[0], ([$r1[-1], $r2[-1]]|max)]
                 | .[$j] = []
                 else .
                 end )
        else .
        end )
  | map(select(. != [])) ;

def testranges:
  [[1.1, 2.2]],
  [[6.1, 7.2], [7.2, 8.3]],
  [[4, 3], [2, 1]],
  [[4, 3], [2, 1], [-1, -2], [3.9, 10]],
  [[1, 3], [-6, -1], [-4, -5], [8, 2], [-6, -6]]
  | "\(.) => \(consolidate)"
;

testranges
