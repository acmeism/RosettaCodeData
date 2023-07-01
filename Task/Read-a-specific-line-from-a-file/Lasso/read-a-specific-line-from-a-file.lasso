local(f) = file('unixdict.txt')
handle => { #f->close }
local(this_line = string,line = 0)
#f->forEachLine => {
	#line++
	#line == 7 ? #this_line = #1
	#line == 7 ? loop_abort
}
#this_line // 6th, which is the 7th line in the file
