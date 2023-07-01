divident := 580
divisor := 34

answer := accumulator := 0
obj := []	, div := divisor

while (div < divident)
{
	obj[2**(A_Index-1)] := div				; obj[powers_of_2] := doublings
	div *= 2						; double up
}

while obj.MaxIndex()						; iterate rows "in the reverse order"
{
	if (accumulator + obj[obj.MaxIndex()] <= divident)	; If (accumulator + current doubling) <= dividend
	{
		accumulator += obj[obj.MaxIndex()]		; add current doubling to the accumulator
		answer += obj.MaxIndex()			; add the powers_of_2 value to the answer.
	}
	obj.pop()						; remove current row
}
MsgBox % divident "/" divisor " = " answer ( divident-accumulator > 0 ? " r" divident-accumulator : "")
