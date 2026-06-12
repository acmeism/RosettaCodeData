package require Tcl 8.6

# Utilities to make the coroutine easier to use
proc provide args {while {![yield $args]} {yield}}
proc next lexer {$lexer 1}
proc pushback lexer {$lexer 0}

# Lexical analyzer coroutine core
proc lexer {str} {
    yield [info coroutine]
    set symbols {+ PLUS - MINUS * MULT / DIV ( LPAR ) RPAR}
    set idx 0
    while 1 {
	switch -regexp -matchvar m -- $str {
	    {^\s+} {
		# No special action for whitespace
	    }
	    {^([-+*/()])} {
		provide [dict get $symbols [lindex $m 1]] [lindex $m 1] $idx
	    }
	    {^(\d+)} {
		provide NUMBER [lindex $m 1] $idx
	    }
	    {^$} {
		provide EOT "EOT" $idx
		return
	    }
	    . {
		provide PARSE_ERROR [lindex $m 0] $idx
	    }
	}
	# Trim the matched string
	set str [string range $str [string length [lindex $m 0]] end]
	incr idx [string length [lindex $m 0]]
    }
}

# Utility functions to help with making an LL(1) parser; ParseLoop handles
# EBNF looping constructs, ParseSeq handles sequence constructs.
proc ParseLoop {lexer def} {
    upvar 1 token token payload payload index index
    foreach {a b} $def {
	if {$b ne "-"} {set b [list set c $b]}
	lappend m $a $b
    }
    lappend m default {pushback $lexer; break}
    while 1 {
	lassign [next $lexer] token payload index
	switch -- $token {*}$m
	if {[set c [catch {uplevel 1 $c} res opt]]} {
	    dict set opt -level [expr {[dict get $opt -level]+1}]
	    return -options $opt $res
	}
    }
}
proc ParseSeq {lexer def} {
    upvar 1 token token payload payload index index
    foreach {t s} $def {
	lassign [next $lexer] token payload index
	switch -- $token $t {
	    if {[set c [catch {uplevel 1 $s} res opt]]} {
		dict set opt -level [expr {[dict get $opt -level]+1}]
		return -options $opt $res
	    }
	} EOT {
	    throw SYNTAX "end of text at position $index"
	} default {
	    throw SYNTAX "\"$payload\" at position $index"
	}
    }
}

# Main parser driver; contains "master" grammar that ensures that the whole
# text is matched and not just a prefix substring. Note also that the parser
# runs the lexer as a coroutine (with a fixed name in this basic demonstration
# code).
proc parse {str} {
    set lexer [coroutine l lexer $str]
    try {
	set parsed [parse.expr $lexer]
	ParseLoop $lexer {
	    EOT {
		return $parsed
	    }
	}
	throw SYNTAX "\"$payload\" at position $index"
    } trap SYNTAX msg {
	return -code error "syntax error: $msg"
    } finally {
	catch {rename $lexer ""}
    }
}

# Now the descriptions of how to match each production in the grammar...
proc parse.expr {lexer} {
    set expr [parse.term $lexer]
    ParseLoop $lexer {
	PLUS - MINUS {
	    set expr [list $token $expr [parse.term $lexer]]
	}
    }
    return $expr
}
proc parse.term {lexer} {
    set term [parse.factor $lexer]
    ParseLoop $lexer {
	MULT - DIV {
	    set term [list $token $term [parse.factor $lexer]]
	}
    }
    return $term
}
proc parse.factor {lexer} {
    ParseLoop $lexer {
	NUMBER {
	    return $payload
	}
	MINUS {
	    ParseSeq $lexer {
		NUMBER {return -$payload}
	    }
	}
	LPAR {
	    set result [parse.expr $lexer]
	    ParseSeq $lexer {
		RPAR {return $result}
	    }
	    break
	}
	EOT {
	    throw SYNTAX "end of text at position $index"
	}
    }
    throw SYNTAX "\"$payload\" at position $index"
}
