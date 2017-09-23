# If n is non-negative, then A002487(n)
# generates an array with at least n elements of
# the A002487 sequence;
# if n is negative, elements are added until (-n)
# is found.
def A002487(n):
  [0,1]
  | until(
      length as $l
      | if n >= 0 then $l >= n
        else      .[$l-1] == -n
	end;
      length as $l
      | ($l / 2) as $n
      | .[$l] = .[$n]
      | if (.[$l-2] == -n) then .
        else .[$l + 1] = .[$n] + .[$n+1]
	end ) ;
