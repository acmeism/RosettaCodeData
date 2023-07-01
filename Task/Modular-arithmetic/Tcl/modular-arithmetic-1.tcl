package require Tcl 8.6
package require pt::pgen

###
### A simple expression parser for a subset of Tcl's expression language
###

# Define the grammar of expressions that we want to handle
set grammar {
PEG Calculator (Expression)
    Expression	<- Term (' '* AddOp ' '* Term)*			;
    Term	<- Factor (' '* MulOp ' '* Factor)*		;
    Fragment	<- '(' ' '* Expression ' '*  ')' / Number / Var	;
    Factor	<- Fragment (' '* PowOp ' '* Fragment)*		;
    Number	<- Sign? Digit+					;
    Var		<- '$' ( 'x'/'y'/'z' )				;

    Digit	<- '0'/'1'/'2'/'3'/'4'/'5'/'6'/'7'/'8'/'9'	;
    Sign	<- '-' / '+'					;
    MulOp	<- '*' / '/'					;
    AddOp	<- '+' / '-'					;
    PowOp	<- '**'						;
END;
}

# Instantiate the parser class
catch [pt::pgen peg $grammar snit -class Calculator -name Grammar]

# An engine that compiles an expression into Tcl code
oo::class create CompileAST {
    variable sourcecode opns
    constructor {semantics} {
	set opns $semantics
    }
    method compile {script} {
	# Instantiate the parser
	set c [Calculator]
	set sourcecode $script
	try {
	    return [my {*}[$c parset $script]]
	} finally {
	    $c destroy
	}
    }

    method Expression-Empty args {}
    method Expression-Compound {from to args} {
	foreach {o p} [list Expression-Empty {*}$args] {
	    set o [my {*}$o]; set p [my {*}$p]
	    set v [expr {$o ne "" ? "$o \[$v\] \[$p\]" : $p}]
	}
	return $v
    }
    forward Expression	my Expression-Compound
    forward Term	my Expression-Compound
    forward Factor	my Expression-Compound
    forward Fragment	my Expression-Compound

    method Expression-Operator {from to args} {
	list ${opns} [string range $sourcecode $from $to]
    }
    forward AddOp	my Expression-Operator
    forward MulOp	my Expression-Operator
    forward PowOp	my Expression-Operator

    method Number {from to args} {
	list ${opns} value [string range $sourcecode $from $to]
    }

    method Var {from to args} {
	list ${opns} variable [string range $sourcecode [expr {$from+1}] $to]
    }
}
