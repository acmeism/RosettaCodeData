# If using gojq:
def keys_unsorted: keys;


### Pseuo-random numbers

# Output: a prn in range(0;$n) where $n is `.`
def prn:
  if . == 1 then 0
  else . as $n
  | ([1, (($n-1)|tostring|length)]|max) as $w
  | [limit($w; inputs)] | join("") | tonumber
  | if . < $n then . else ($n | prn) end
  end;

def sample:
  if length == 0 # e.g. null or []
  then null
  else .[length|prn]
  end;


### The tasks

# The words in $text
def words:
  [$text | sub("\\s*$";"") | splits("  *")];

def markov($keySize; $outputSize):
  if $keySize < 1
  then "Key size can't be less than 1" | error
  else words as $words
  |  ($words|length|length) as $wordCount
  | if $outputSize < $keySize or $outputSize > $wordCount
    then "Requested output size is greater than the number of words in the given text" | error
    else
    (reduce range(0; 1+$wordCount - $keySize) as $i ( {};
        ($words[$i:$i + $keySize] | join(" ")) as $prefix
        | (if ($i + $keySize < $wordCount) then $words[$i + $keySize] else "" end) as $suffix
        | .[$prefix] += [$suffix] )) as $dict
    | { output: [] }
    | ($dict|keys_unsorted) as $keys
    # Start with a capitalized word, possibly following a quotation mark:
    | .prefix = ($keys | map(select(test("^['A-Z][^.]*$"))) | sample)
    | .output += (.prefix|split(" "))
    | last(label $out
         | foreach range(1; 1+$wordCount) as $n (.;
             ($dict[.prefix]|sample) as $nextWord
             | if $nextWord | length == 0
               then ., break $out
               else .output += [$nextWord]
               | if (.output|length) >= $outputSize
               then ., break $out
              else .prefix = (.output[$n:$n + $keySize] | join(" "))
              end
              end ))
    | .output[:$outputSize] | join(" ")
    end
  end ;

markov(3; 100)
