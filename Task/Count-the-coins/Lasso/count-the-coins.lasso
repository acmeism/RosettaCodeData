define cointcoins(
	target::integer,
	operands::array
) => {

	local(
		targetlength	= #target + 1,
		operandlength	= #operands -> size,
		output			= staticarray_join(#targetlength,0),
		outerloopcount
	)

	#output -> get(1) = 1

	loop(#operandlength) => {
		#outerloopcount = loop_count
		loop(#targetlength) => {

			if(loop_count >= #operands -> get(#outerloopcount) and loop_count - #operands -> get(#outerloopcount) > 0) => {
				#output -> get(loop_count) += #output -> get(loop_count - #operands -> get(#outerloopcount))
			}
		}
	}

	return #output -> get(#targetlength)
}

cointcoins(100, array(1,5,10,25,))
'<br />'
cointcoins(100000, array(1, 5, 10, 25, 50, 100))
