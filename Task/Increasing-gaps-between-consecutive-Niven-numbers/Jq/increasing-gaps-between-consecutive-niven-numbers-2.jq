# input: the largest Niven number to be considered (null => infinite)
# output: a stream of informative JSON objects -
# {gap_index, gap, niven_index, previous}
def nivens:
  (. // infinite) as $limit
  | { gap: 0,
      gap_index: 1,
      niven: 1,
      niven_index: 1}
  | foreach range(2; $limit+1) as $n (.;
      .emit = false
      | if $n % ($n | digit_sum) == 0
        then if $n > .niven + .gap
             then .gap = $n - .niven
	     | .emit = {gap_index, gap, niven_index, niven}
     	     | .gap_index += 1
	     else .
	     end
        | .niven = $n
        | .niven_index += 1
        else .
	end;
      select(.emit).emit );

"Gap index  Gap  Niven index  Niven number",
"---------  ---  -----------  ------------",
( 1E7 | nivens
  | "\(.gap_index|lpad(9)) \(.gap|lpad(4)) \(.niven_index|lpad(12)) \(.niven|lpad(13))" )
