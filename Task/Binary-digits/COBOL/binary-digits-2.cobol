IDENTIFICATION DIVISION.
PROGRAM-ID. binary-conversion.

DATA DIVISION.
WORKING-STORAGE SECTION.
01 binary-number   pic X(21).
01 digit           pic 9.
01 n               pic 9(7).
01 nstr            pic X(7).
01 ptr			   pic 99.

PROCEDURE DIVISION.
	display "Number: " with no advancing.
	accept nstr.
	move nstr to n.
	move zeroes to binary-number.
	move length binary-number to ptr.
	perform until n equal 0
		divide n by 2 giving n remainder digit
		move digit to binary-number(ptr:1)
		subtract 1 from ptr
		if ptr < 1
			exit perform
		end-if
	end-perform.
	display binary-number.
	stop run.
