# Input: an upper bound greater than 2
# Output: the array of coprime triplets [1,2 ... n] where n is less than the upper bound
def coprime_triplets:
  . as $less_than
  | {cpt: [1, 2], m:0}
  | until( .m >= $less_than;
        .m = 1
	| .cpt as $cpt
        | until( (.m | IN($cpt[]) | not) and (gcd(.m; $cpt[-1]) == 1) and (gcd(.m; $cpt[-2]) == 1);
            .m += 1 )
        | .cpt = $cpt + [.m] )
  | .cpt[:-1];

50 | coprime_triplets
| (nwise(10) | map(lpad(2)) | join(" "))
