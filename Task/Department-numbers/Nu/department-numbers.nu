# Loop through all combinations from 1 to 7
let numbers = 1..7

# Create all possible unique permutations of 3 different numbers
let combos = (
  $numbers | each { |p|
    $numbers | each { |s|
      $numbers | each { |f|
        if ($p != $s and $p != $f and $s != $f) {
          {police: $p, sanitation: $s, fire: $f}
        } else {
          null
        }
      }
    }
  } | flatten | flatten | flatten
)

# Filter combinations by sum and police even requirement
$combos | filter { |it|
  ($it.police + $it.sanitation + $it.fire) == 12 and ($it.police mod 2) == 0
} | sort-by police sanitation fire

}
