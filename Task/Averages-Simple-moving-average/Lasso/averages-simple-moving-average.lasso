define simple_moving_average(a::array,s::integer)::decimal => {
	#a->size == 0 ? return 0.00
	#s == 0 ? return 0.00
	#a->size == 1 ? return decimal(#a->first)
	#s == 1 ? return decimal(#a->last)
	local(na = array)
	if(#a->size <= #s) => {
		#na = #a
	else
		local(ar = #a->ascopy)
		#ar->reverse
		loop(#s) => { #na->insert(#ar->get(loop_count)) }
	}
	#s > #na->size ? #s = #na->size
	return (with e in #na sum #e) / decimal(#s)
}
// tests:
'SMA 3 on array(1,2,3,4,5,5,4,3,2,1): '
simple_moving_average(array(1,2,3,4,5,5,4,3,2,1),3)

'\rSMA 5 on array(1,2,3,4,5,5,4,3,2,1): '
simple_moving_average(array(1,2,3,4,5,5,4,3,2,1),5)

'\r\rFurther example: \r'
local(mynumbers = array, sma_num = 5)
loop(10) => {^
	#mynumbers->insert(integer_random(1,100))
	#mynumbers->size + ' numbers: ' + #mynumbers
	 ' SMA3 is: ' + simple_moving_average(#mynumbers,3)
	 ', SMA5 is: ' + simple_moving_average(#mynumbers,5)
	'\r'
^}
