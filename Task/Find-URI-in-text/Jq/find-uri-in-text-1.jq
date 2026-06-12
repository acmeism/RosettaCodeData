# input: a JSON string
# output: a stream of URIs
# Each input string may contain more than one URI.
def findURIs:
    match( "
	[a-z][-a-z0-9+.]*:		# Scheme...
	(?=[/\\w])			# ... but not just the scheme
	(?://[-\\w.@:]+)?		# Host
	[-\\w.~/%!$&'()*+,;=]*		# Path
	(?:\\?[-\\w.~%!$&'()*+,;=/?]*)?	# Query
	(?:[#][-\\w.~%!$&'()*+,;=/?]*)?	# Fragment

     "; "gx")
    | .string ;

# Example: read in a file of arbitrary text and
# produce a stream of the URIs that are identified.
split("\n")[] | findURIs
