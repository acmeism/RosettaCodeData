package require Tcl 8.6
package require Thread

# Pooled computation engine; runs event loop internally
namespace eval pooled {
    variable poolSize 3; # Needs to be tuned to system size

    proc computation {computationDefinition entryPoint values} {
	variable result
	variable poolSize
	# Add communication shim
	append computationDefinition [subst -nocommands {
	    proc poolcompute {value target} {
		set outcome [$entryPoint \$value]
		set msg [list set ::pooled::result(\$value) \$outcome]
		thread::send -async \$target \$msg
	    }
	}]

	# Set up the pool
	set pool [tpool::create -initcmd $computationDefinition \
		      -maxworkers $poolSize]

	# Prepare to receive results
	unset -nocomplain result
	array set result {}

	# Dispatch the computations
	foreach value $values {
	    tpool::post $pool [list poolcompute $value [thread::id]]
	}

	# Wait for results
	while {[array size result] < [llength $values]} {vwait pooled::result}

	# Dispose of the pool
	tpool::release $pool

	# Return the results
	return [array get result]
    }
}
