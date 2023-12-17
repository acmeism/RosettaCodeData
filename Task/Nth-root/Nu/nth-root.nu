def "math root" [n] {$in ** (1 / $n)}

1..10 | each {|it|
	1..10 | reduce --fold {index: $it} {|root acc|
		$acc | insert $"root ($root)" ($it | math root $root | into string --decimals 4 )
	}
}
