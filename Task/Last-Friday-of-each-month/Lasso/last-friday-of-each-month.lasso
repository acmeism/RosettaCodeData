define isLeapYear(y::integer) => {
	#y % 400 == 0 ? return true
	#y % 100 == 0 ? return false
	#y % 4 == 0 ? return true
	return false
}
define fridays(y::integer) => {
	local(out = array)
	loop(12) => {
		local(last = 28)
		loop_count == 2 && isLeapYear(#y) ? #last = 29
		array(4,6,9,11) >> loop_count ? #last == 30
		#last == 28 && loop_count != 2 ? #last = 31
		local(start = date(-year=#y,-month=loop_count,-day=#last))
		while(#start->dayofweek != 6) => {
			#start->subtract(-day=1)
		}
		#out->insert(#start)
	}
	return #out
}
with f in fridays(2012) do => {^
	#f->format('%Q') + '\r'
^}
