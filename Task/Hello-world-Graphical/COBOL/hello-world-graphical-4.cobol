	program-id. ghello.
	data division.
	working-storage section.
	01	var	pic x(1).
	01	lynz	pic 9(3).
	01 	colz	pic 9(3).
	01	msg	pic x(15) value "Goodbye, world!".
	procedure division.
		accept lynz from lines end-accept
		divide lynz by 2 giving lynz.
		accept colz from columns end-accept
		divide colz by 2 giving colz.
		subtract 7 from colz giving colz.
		display msg
			at line number lynz
			column number colz
		end-display
		accept var end-accept
		stop run.
