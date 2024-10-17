let means = {
  A: { math avg }
  G: { ($in | math product) ** (1 / ($in | length)) }
  H: { each { 1 / $in } | math avg | 1 / $in }
}

let $set = seq 1 10

$means | items {|i f| {index: $i mean: ($set | do $f)} }
