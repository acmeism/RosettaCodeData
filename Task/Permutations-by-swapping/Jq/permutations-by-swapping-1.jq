# The helper function, _recurse, is tail-recursive and therefore in
# versions of jq with TCO (tail call optimization) there is no
# overhead associated with the recursion.

def permutations:
  def abs: if . < 0 then -. else . end;
  def sign: if . < 0 then -1 elif . == 0 then 0 else 1 end;
  def swap(i;j): .[i] as $i | .[i] = .[j] | .[j] = $i;

  # input: [ parity, extendedPermutation]
  def _recurse:
    .[0] as $s | .[1] as $p | (($p | length) -1) as $n
    | [ $s, ($p[1:] | map(abs)) ],
      (reduce range(2; $n+1) as $i
         (0;
          if $p[$i] < 0 and -($p[$i]) > ($p[$i-1]|abs) and -($p[$i]) > ($p[.]|abs)
          then $i
          else .
          end)) as $k
      | (reduce range(1; $n) as $i
           ($k;
            if $p[$i] > 0 and $p[$i] > ($p[$i+1]|abs) and $p[$i] > ($p[.]|abs)
            then $i
            else .
            end)) as $k
      | if $k == 0 then empty
        else (reduce range(1; $n) as $i
	       ($p;
                if (.[$i]|abs) > (.[$k]|abs) then .[$i] *= -1
                else .
                end )) as $p
        | ($k + ($p[$k]|sign)) as $i
        | ($p | swap($i; $k)) as $p
        | [ -($s), $p ] | _recurse
        end ;

  . as $in
  | length as $n
  | (reduce range(0; $n+1) as $i ([]; . + [ -$i ])) as $p
  # recurse state: [$s, $p]
  | [ 1, $p] | _recurse
  | .[1] as $p
  | .[1] = reduce range(0; $n) as $i ([]; . + [$in[$p[$i]  - 1]]) ;

def count(stream): reduce stream as $x (0; .+1);
