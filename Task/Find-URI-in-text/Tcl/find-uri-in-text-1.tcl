proc findURIs {text args} {
    # This is an ERE with embedded comments. Rare, but useful with something
    # this complex.
    set URI {(?x)
	[a-z][-a-z0-9+.]*:		# Scheme...
	(?=[/\w])			# ... but not just the scheme
	(?://[-\w.@:]+)?		# Host
	[-\w.~/%!$&'()*+,;=]*		# Path
	(?:\?[-\w.~%!$&'()*+,;=/?]*)?	# Query
	(?:[#][-\w.~%!$&'()*+,;=/?]*)?	# Fragment
    }
    regexp -inline -all {*}$args -- $URI $text
}
