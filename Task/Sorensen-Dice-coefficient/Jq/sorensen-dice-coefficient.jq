### Generic preliminaries

def count(s): reduce s as $x (0; .+1);

def lpad($len): tostring | ($len - length) as $l | (" " * $l) + .;

# Emit the count of the common items in the two given sorted arrays
# viewed as multisets
def count_commonality_of_multisets($A; $B):
  # Returns a stream of the common elements
  def pop:
      .[0] as $i
      | .[1] as $j
      | if $i == ($A|length) or $j == ($B|length) then empty
        elif $A[$i] == $B[$j] then 1, ([$i+1, $j+1] | pop)
        elif $A[$i] <  $B[$j] then [$i+1, $j] | pop
        else [$i, $j+1] | pop
        end;
  count([0,0] | pop);

# Emit an array of the normalized bigrams of the input string
def bigrams:
  # Emit a stream of the bigrams of the input string blindly
  def bg: . as $in | range(0;length-1 ) | $in[.:.+2];
  ascii_downcase | [splits("  *") | bg];


### The Sorensen-Dice coefficient

def sorensen($a; $b):
  ($a | bigrams | sort) as $A
  | ($b | bigrams | sort) as $B
  | 2 * count_commonality_of_multisets($A; $B) / (($A|length) + ($B|length));


### Exercises

def exercises:
    "Primordial primes",
    "Sunkist-Giuliani formula",
    "Sieve of Euripides",
    "Chowder numbers"
;

[inputs] as $phrases
| exercises as $test
| [ range(0; $phrases|length) as $i
    | [sorensen($phrases[$i]; $test), $phrases[$i] ] ]
| sort_by(first)
| .[-5:]
| reverse
| "\($test) >",
   map( "  \(first|tostring|.[:4]|lpad(4))  \(.[1])")[],
   ""
