t: {<name> went for a walk in the park. <he or she> found a <noun>. <name> decided to take it home.}
view layout [a: area wrap t  btn "Done" [x: a/text unview]]
w: copy []
parse x [any [to "<" copy brackets thru ">" (append w brackets)] to end]
w: unique w
foreach i w [replace/all x i ask join i ": "]
alert x
