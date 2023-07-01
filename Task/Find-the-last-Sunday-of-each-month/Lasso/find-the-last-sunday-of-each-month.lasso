local(
	year	= integer(web_request -> param('year') || 2013),
	date	= date(#year + '-1-1'),
	lastsu	= array,
	lastday
)

with month in generateseries(1,12) do {
	#date -> day = 1
	#date -> month = #month
	#lastday = #date -> month(-days)
	#date -> day = #lastday
	loop(7)	=> {
		if(#date -> dayofweek == 1) => {
			#lastsu -> insert(#date -> format(`dd MMMM`))
			loop_abort
		}
		#date -> day--
	}
}
#lastsu -> join('<br />')
