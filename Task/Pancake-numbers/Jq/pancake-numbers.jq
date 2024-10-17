# Input: a JSON object
# Output: the first key found (using keys_unsorted) with a maximal
#   associated value, or null
def findMax:
  . as $in
  | reduce keys_unsorted[] as $key ( null;
      if . == null or $in[$key] > .max then {$key, max: $in[$key]}
      end )
  | .key;

# Input: a (small) positive integer
# Output: its pancake number
def pancake:
  . as $len
  | [range(1; $len + 1)] as $goalStack
  | { numStacks: 1,
      stacks: {($goalStack|tostring): 0}
    }
  | .newStacks = .stacks
  | first(
      foreach range(1;1001) as $i (.;
        .nextStacks = {}
        | reduce (.newStacks|keys_unsorted)[] as $key (.;
            ($key|fromjson) as $arr
            | .pos = 2
            | until (.pos > $len;
                ((($arr[:.pos] | reverse) + $arr[.pos:]) | tostring) as $newStack
                | if (.stacks | has($newStack) | not)
                  then .nextStacks[$newStack] = $i
                  end
                | .pos += 1 ) )
      | .newStacks = .nextStacks
      | .stacks = (.stacks + .newStacks)
      | (.stacks|length) as $perms
      | if $perms == .numStacks
        then .emit = [(.stacks|findMax), $i - 1]
        else .numStacks = $perms
        end )
    | select(.emit).emit );

"The maximum number of flips to sort a given number of elements is:",
(range (1; 11)
 | . as $i
 | pancake as [$example, $steps]
 | "pancake(\($i)) = \($steps)  example: \($example)"
)
