"exec" "gst" "-f" "$0" "$0" "$*"
"exit"

[
	Transcript show: 'Throwing yawp'; cr.
	self error: 'Yawp!'.
] on: Error do: [ :e |
	Transcript show: 'Caught yawp'; cr.
].
