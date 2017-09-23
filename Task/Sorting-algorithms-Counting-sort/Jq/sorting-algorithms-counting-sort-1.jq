def countingSort(min; max):
  . as $in
  | reduce range(0;length) as $i
      ( {};
        ($in[$i]|tostring) as $s | .[$s] += 1 # courtesy of the fact that in jq, (null+1) is 1
      )
  | . as $hash
  # now construct the answer:
  | reduce range(min; max+1) as $i
      ( [];
        ($i|tostring) as $s
        | if $hash[$s] == null then .
          else reduce range(0; $hash[$s]) as $j (.; . + [$i])
          end
      );
