identification division.
program-id. recurse.
data division.
working-storage section.
01 depth-counter	pic 9(3).
01  install-address   	usage is procedure-pointer.
01  install-flag      	pic x comp-x value 0.
01  status-code       	pic x(2) comp-5.
01  ind               	pic s9(9) comp-5.


linkage section.
01  err-msg           	pic x(325).

procedure division.
100-main.

	set install-address to entry "300-err".
	
	call "CBL_ERROR_PROC" using install-flag
		install-address
		returning status-code.

	if status-code not = 0
		display "ERROR INSTALLING ERROR PROC"
		stop run
        end-if

 	move 0 to depth-counter.
	display 'Mung until no good.'.
	perform 200-mung.
	display 'No good.'.
	stop run.

200-mung.
	add 1 to depth-counter.
	display depth-counter.
	perform 200-mung.
300-err.
	entry "300-err" using err-msg.
	perform varying ind from 1 by 1
		until (err-msg(ind:1) = x"00") or (ind = length of err-msg)
			continue
	end-perform

	display err-msg(1:ind).

*> room for a better-than-abrupt death here.
	
	exit program.
