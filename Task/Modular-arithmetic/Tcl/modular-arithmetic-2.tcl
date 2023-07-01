# The semantic evaluation engine; this is the part that knows mod arithmetic
oo::class create ModEval {
    variable mod
    constructor {modulo} {set mod $modulo}
    method value {literal} {return [expr {$literal}]}
    method variable {name} {return [expr {[set ::$name]}]}
    method + {a b} {return [expr {($a + $b) % $mod}]}
    method - {a b} {return [expr {($a - $b) % $mod}]}
    method * {a b} {return [expr {($a * $b) % $mod}]}
    method / {a b} {return [expr {($a / $b) % $mod}]}
    method ** {a b} {
	# Tcl supports bignums natively, so we use the naive version
	return [expr {($a ** $b) % $mod}]
    }
    export + - * / **
}

# Put all the pieces together
set comp [CompileAST new [ModEval create mod13 13]]
