def maximally_different_adjacent_pairs:
  . as $in
  | reduce range(1; length) as $i ({ maxDiff: -1};
      (($in[$i-1] - $in[$i])|length) as $diff  # length being abs
      | if $diff > .maxDiff
        then .maxDiff = $diff
        | .maxPairs = [[$in[$i-1], $in[$i]]]
        elif $diff == .maxDiff
        then .maxPairs += [[$in[$i-1], $in[$i]]]
	else .
	end
      );

# Example:
[1, 8, 2, -3, 0, 1, 1, -2.3, 0, 5.5, 8,6, 2, 9, 11, 10, 3]
| maximally_different_adjacent_pairs
