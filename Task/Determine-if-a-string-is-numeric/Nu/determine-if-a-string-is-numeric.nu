def is-numeric [] {try {into float | true} catch {false}}

["1" "12" "-3" "5.6" "-3.14" "one" "cheese"] | each {{k: $in, v: ($in | is-numeric)}}
