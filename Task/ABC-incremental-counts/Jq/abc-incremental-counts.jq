def count(stream): reduce stream as $x (0; .+1);

# Count the number of occurrences of $char in .
def occurrences($char):
  ($char[0:1]|explode[0]) as $codepoint
  | count( explode[] | select(. == $codepoint));

# Input: an array of "words"
# Output: an array of words satisfying the conditions
def abcIncrementalCounts($letters; $minCount):
  reduce (.[] | ascii_downcase) as $word ([];
    ($word | occurrences($letters[0])) as $c1
    | if $c1 < $minCount then .
      else ($word|occurrences($letters[1])) as $c2
      | if $c2 < $minCount then .
        else ($word|occurrences($letters[2])) as $c3
        | if $c3 < $minCount then .
          else  ([$c1, $c2, $c3] | sort) as $l
          | if $l[1] != ($l[0] + 1) or $l[2] != ($l[1] + 1) then .
            else . + [$word]
            end
          end
        end
      end);

def letters:
  [["a", "b", "c"], ["t", "h", "e"], ["c", "i", "o"]];

# Requires: $mincount
# Reads from STDIN
def incremental_counts:
   [inputs]
   | range(0; letters|length) as $j
   | letters[$j] as $letters
   | "Letters: \($letters) -- Minimum count \($mincount[$j])",
      ( (abcIncrementalCounts($letters; $mincount[$j]) ) as $res
        | if ($res|length) > 0
          then $res[] | sub("\r$";"")
          else "<none>"
          end ),
      "";

incremental_counts
