# Output: { characters: array_of_characters_in_decreasing_order_of_frequency, frequency: object}
def MostFreqKHashing($K):
  def chars: explode | range(0;length) as $i | [.[$i]] | implode;
  . as $in
  | bow(tostring | chars) as $bow
  | $bow
  | to_entries
  | sort_by_decreasing(.value)  # if two chars have same frequency than get the first occurrence in $in
  | (reduce .[0:$K][] as $kv ({}; .[$kv.key] = $kv.value) ) as $frequency
  | {characters: map(.key)[:$K], $frequency};

def MostFreqKSimilarity($in1; $in2; $K):
  [$in1, $in2] | map( MostFreqKHashing($K)) as [$s1, $s2]
  | reduce $s1.characters[] as $c (0;
      $s2.frequency[$c] as $f
      | if $f then . + $s1.frequency[$c] + $f
        else . end) ;

def MostFreqKSDF($inputStr1; $inputStr2; $K; $maxDistance):
    $maxDistance - MostFreqKSimilarity($inputStr1; $inputStr2; $K);

def MostFreqKSDF($K; $maxDistance):
   . as [$inputStr1, $inputStr2]
   | $maxDistance - MostFreqKSimilarity($inputStr1; $inputStr2; $K);

def task2:
  ["night", "nacht"],
  ["my", "a"],
  ["research", "research"],
  ["research", "seeking"],
  ["significant", "capabilities"]
  | MostFreqKSDF(2; 10) as $sdk
  | [., $sdk] ;

def task100:
  ["LCLYTHIGRNIYYGSYLYSETWNTGIMLLLITMATAFMGYVLPWGQMSFWGATVITNLFSAIPYIGTNLV",
   "EWIWGGFSVDKATLNRFFAFHFILPFTMVALAGVHLTFLHETGSNNPLGLTSDSDKIPFHPYYTIKDFLG"]
  | MostFreqKSDF(2; 100);

task2, task100
