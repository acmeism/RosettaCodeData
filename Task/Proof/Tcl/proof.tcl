package require datatype
datatype define Int = Zero | Succ val
datatype define EO = Even | Odd

proc evenOdd val {
    global environment
    datatype match $val {
	case Zero		-> { Even }
	case [Succ [Succ x]]	-> { evenOdd $x }
	case t		-> {
	    set term [list evenOdd $t]
	    if {[info exists environment($term)]} {
		return $environment($term)
	    } elseif {[info exists environment($t)]} {
		return [evenOdd $environment($t)]
	    } else {
		return $term
	    }
	}
    }
}

proc add {a b} {
    global environment
    datatype match $a {
	case Zero	-> { return $b }
	case [Succ x]	-> { Succ [add $x $b] }
	case t		-> {
	    datatype match $b {
		case Zero	-> { return $t }
		case [Succ x]	-> { Succ [add $t $x] }
		case t2		-> {
		    set term [list add $t $t2]
		    if {[info exists environment($term)]} {
			return $environment($term)
		    } elseif {[info exists environment($t)]} {
			return [add $environment($t) $t2]
		    } elseif {[info exists environment($t2)]} {
			return [add $t $environment($t2)]
		    } else {
			return $term
		    }
		}
	    }
	}
    }
}

puts "BASE CASE"
puts "evenOdd Zero = [evenOdd Zero]"
puts "evenOdd \[add Zero Zero\] = [evenOdd [add Zero Zero]]"

puts "\nITERATIVE CASE"
set environment([list evenOdd p]) Even
puts "if evenOdd p = Even..."
puts "\tevenOdd \[Succ \[Succ p\]\] = [evenOdd [Succ [Succ p]]]"
unset environment
puts "if evenOdd \[add p q\] = Even..."
set environment([list evenOdd [add p q]]) Even
foreach {a b} {
    p q
    {Succ {Succ p}} q
    p {Succ {Succ q}}
    {Succ {Succ p}} {Succ {Succ q}}
} {
    puts "\tevenOdd \[[list add $a $b]\] = [evenOdd [add $a $b]]"
}
