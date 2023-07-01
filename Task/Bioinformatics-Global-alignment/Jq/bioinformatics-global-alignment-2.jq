# Give a synoptic view of the input string,
# highlighting the occurrence of ACGTU letters
def synopsis:
  ["A", "C", "G", "T", "U"] as $standard
  | . as $seq
  | bow(explode | map([.]|implode)[]) as $bases
  | ("Nucleotide counts for \($seq):\n"),
    (($standard + ($bases|keys - $standard))[] | "\(.): \($bases[.]//0)"),
    "__",
    "Σ: \($seq|length)" ;

# If the strings, $s1 and $s2, overlap by at least $minimumoverlap characters,
# return { i1: <index in $s1 where overlap starts>,  overlap: <overlapping string>},
# otherwise, return null
def overlap_info($s1; $s2; $minimumoverlap):
  first( range(0; $s1|length + 1 - $minimumoverlap) as $i1
         | $s1[$i1:] as $overlap
         | select($s2 | startswith($overlap))
	 | {$i1, $overlap} ) // null ;

# Input: an array of strings
# Remove duplicates and strings contained within a larger string
def deduplicate:
  unique
  | . as $arr
  | reduce range(0;length) as $i ([];
      $arr[$i] as $s1
      | if any( $arr[] | select(. != $s1); index($s1))
        then .
	else . + [$s1]
	end);

# Given an array of deduplicated strings, attempt to find a superstring
# composed of these strings in the same order;
# return it if found, else null.
def relevant($min):
  . as $in
  | length as $length
  | {s: .[0], i:0}
  | until (.s == null or .i >= $length - 1;
       .i as $i
       # Since the strings have been deduplicated we can use $in[$i]:
       | overlap_info($in[$i]; $in[$i+1]; $min) as $overlap
       | if $overlap then .s += $in[$i+1][$overlap.overlap|length:]
         else .s = null
	 end
       | .i += 1 )
   | .s ;

# Input: an array of strings
# Return shortest common superstring
def shortest_common_superstring:
  deduplicate as $ss
  | reduce ($ss | permutations) as $perm ({shortestsuper: ($ss | add) };
      ($perm | relevant(1)) as $candidate
      | if $candidate and ($candidate|length) < (.shortestsuper|length)
        then .shortestsuper = $candidate
        else . end)
  | .shortestsuper;
