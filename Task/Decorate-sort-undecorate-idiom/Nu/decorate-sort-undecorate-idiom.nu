def 'sort by key' [keyfunc] {
	( each {|v| {k: ($v | do $keyfunc ), v: $v}}
	| sort-by k
	| each {get v} )
}

"Rosetta Code is a programming chrestomathy site" | split words | sort by key {str length}
