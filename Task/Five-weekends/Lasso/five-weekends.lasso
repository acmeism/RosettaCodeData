local(
	months		= array(1, 3, 5, 7, 8, 10, 12),
	fivemonths	= array,
	emptyears	= array,
	checkdate	= date,
	countyear
)

#checkdate -> day = 1

loop(-from = 1900, -to = 2100) => {

	#countyear = false

	#checkdate -> year = loop_count

	with month in #months
	do {
		#checkdate -> month = #month
		if(#checkdate -> dayofweek == 6) => {
			#countyear = true
			#fivemonths -> insert(#checkdate -> format(`YYYY MMM`))
		}
	}

	if(not #countyear) => {
		#emptyears -> insert(loop_count)
	}

}
local(
	monthcount	= #fivemonths -> size,
	output		= 'Total number of months ' + #monthcount + '<br /> Starting five months '
)

loop(5) => {
	#output -> append(#fivemonths -> get(loop_count) + ', ')
}

#output -> append('<br /> Ending five months ')

loop(-from = #monthcount - 5, -to = #monthcount) => {
	#output -> append(#fivemonths -> get(loop_count) + ', ')
}

#output -> append('<br /> Years with no five weekend months ' + #emptyears -> size + '<br />')

with year in #emptyears do {
	#output -> append(#year + ', ')
}

#output
