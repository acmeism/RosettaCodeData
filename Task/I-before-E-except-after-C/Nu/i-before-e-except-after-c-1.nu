# Fetch and process the word list
let words = open unixdict.txt | lines | where { ($in | str length) > 3 }

# Function to count matches for a pattern
def count-pattern [pattern: string] {
    $words | where $it =~ $pattern | length
}

# Count occurrences for "I before E" rule
let ie_not_c = (count-pattern "(^|[^c])ie")      # ie not preceded by c
let ei_not_c = (count-pattern "(^|[^c])ei")      # ei not preceded by c

# Count occurrences for "E before I" rule
let cei = (count-pattern "cei")                  # ei preceded by c
let cie = (count-pattern "cie")                  # ie preceded by c

# Check plausibility (more than 2x occurrences of opposite)
let rule1_plausible = ($ie_not_c > ($ei_not_c * 2))
let rule2_plausible = ($cei > ($cie * 2))

# Output results
print [
  $"Analyzing 'I before E when not preceded by C':"
  $"  correct for     : ($ie_not_c)"
  $"  not correct for : ($ei_not_c)"
  $"  Plausible: ($rule1_plausible)"
  $""
  $"Analyzing 'E before I when preceded by C':"
  $"  correct for     : ($cei)"
  $"  not correct for : ($cie)"
  $"  Plausible: ($rule2_plausible)"
  ]
