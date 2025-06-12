# Fetch and filter words
let words = open unixdict.txt | lines | where { $in | str length | $in > 3 }

# Define patterns and their processing in a functional way
let patterns = [
    { name: "ie_not_c", pattern: "(^|[^c])ie", desc: "I before E when not preceded by C" }
    { name: "ei_not_c", pattern: "(^|[^c])ei", desc: null }
    { name: "cei", pattern: "cei", desc: "E before I when preceded by C" }
    { name: "cie", pattern: "cie", desc: null }
]

# Count matches for each pattern functionally
let counts = $patterns |
     each { |p|
        $p | upsert count ($words | where $it =~ $p.pattern | length)
    }

# Calculate plausibility using match
let results = $counts |
     each { |row|
        match $row.name {
            "ie_not_c" => {
                let opposite = ($counts | where name == "ei_not_c" | get count.0)
                $row | upsert plausible ($row.count > ($opposite * 2))
            }
            "cei" => {
                let opposite = ($counts | where name == "cie" | get count.0)
                $row | upsert plausible ($row.count > ($opposite * 2))
            }
            _ => $row
        }
    }

# Format and print results functionally
$results |
     where desc != null |
     each { |rule|
        let opposite = ($results | where name == (if $rule.name == "ie_not_c" { "ei_not_c" } else { "cie" }) | get 0)
        [
            $"Analyzing '($rule.desc)':"
            $"  correct for     : ($rule.count)"
            $"  not correct for : ($opposite.count)"
            $"  Plausible: ($rule.plausible)"
            ""
        ]
    } |
     flatten |
     print $in
