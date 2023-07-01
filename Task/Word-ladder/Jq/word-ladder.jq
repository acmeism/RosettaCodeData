def count(stream): reduce stream as $i (0; .+1);

def words: [inputs];  # one way to read the word list

def oneAway($a; $b):
  ($a|explode) as $ax
  | ($b|explode) as $bx
  | 1 == count(range(0; $a|length) | select($ax[.] != $bx[.]));

# input: the word list
def wordLadder($a; $b):
    ($a|length) as $len
    | { poss: map(select(length == $len)),      # the relevant words
        todo:  [[$a]]                           # possible chains
      }
    | until ( ((.todo|length) == 0) or .solution;
        .curr = .todo[0]
        | .todo |= .[1:]
	| .curr[-1] as $c
        | (.poss | map(select( oneAway(.; $c) ))) as $next
        | if ($b | IN($next[]))
          then .curr += [$b]
          | .solution = (.curr|join(" -> "))
          else .poss = (.poss - $next)
	  | .curr as $curr
          | .todo = (reduce range(0; $next|length) as $i (.todo;
                       . + [$curr + [$next[$i] ]] ))
          end )
    | if .solution then .solution
      else "There is no ladder from \($a) to \($b)."
      end ;

def pairs:
    ["boy", "man"],
    ["girl", "lady"],
    ["john", "jane"],
    ["child", "adult"],
    ["word", "play"]
;

words
| pairs as $p
| wordLadder($p[0]; $p[1])
