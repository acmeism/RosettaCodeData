def partDiffDiff($n):
  if ($n % 2) == 1 then ($n+1) / 2 else $n+1 end;

# in:  {n, partDiffMemo}
# out: object with possibly updated memoization
def partDiff:
  .n as $n
  | if .partDiffMemo[$n] then .
    elif $n<2 then .partDiffMemo[$n]=1
    else ((.n=($n-1)) | partDiff)
    | .partDiffMemo[$n] = .partDiffMemo[$n-1] + partDiffDiff($n-1)
    end;

# in:  {n, memo, partDiffMemo}
#      where `.memo[i]` memoizes partitions(i)
#      and   `.partDiffMemo[i]` memoizes partDiff(i)
# out: object with possibly updated memoization
def partitionsM:
  .n as $n
  | if .memo[$n] then .
    elif $n<2 then .memo[$n] = 1
    else label $out
    | foreach range(1; $n+2) as $i (.emit = false | .psum = 0;
        if $i > $n then .emit = true
        else ((.n = $i) | partDiff)
	| .partDiffMemo[$i] as $pd
        | if $pd > $n then .emit=true, break $out
          else {psum, emit} as $local  # for restoring relevant state
	  |  ((.n = ($n-$pd)) | partitionsM)
	  | .memo[$n-$pd] as $increment
	  | . + $local                 # restore
          | if (($i-1)%4)<2
            then .psum += $increment
            else .psum -= $increment
            end
	  end
        end;
        select(.emit) )
    | .memo[$n] = .psum
    end ;

def partitionsP:
  . as $n
  | {n: $n, memo:[], partDiffMemo:[]}
  | partitionsM
  | .memo[$n];

# Stretch goal:
6666 | partitionsP
