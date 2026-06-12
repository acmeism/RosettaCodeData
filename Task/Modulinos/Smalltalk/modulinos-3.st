"exec" "gst" "-f" "$0" "$0" "$@"
"exit"

Object subclass: ScriptedMain [
	ScriptedMain class >> meaningOfLife [ ^42 ]
]

| main |

main := [
	Transcript show: 'Main: The meaning of life is ', ((ScriptedMain meaningOfLife) printString); cr.
].

(((Smalltalk getArgc) > 0) and: [ ((Smalltalk getArgv: 1) endsWith: 'scriptedmain.st') ]) ifTrue: [
	main value.
].
