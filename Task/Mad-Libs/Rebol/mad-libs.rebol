t: {<name> went for a walk in the park. <he or she> found a <noun>. <name> decided to take it home.}
view layout [a: area wrap t  btn "Done" [x: a/text unview]]
parse x [any [to "<" copy b thru ">" (append w: [] b)] to end]
foreach i unique w [replace/all x i ask join i ": "]  alert x
