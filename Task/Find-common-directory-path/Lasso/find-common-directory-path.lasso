#!/usr/bin/lasso9

local(
	path1 = '/home/user1/tmp/coverage/test' -> split('/'),
	path2 = '/home/user1/tmp/covert/operator' -> split('/'),
	path3 = '/home/user1/tmp/coven/members' -> split('/')
)

define commonpath(...) => {
	local(shared = #rest -> get(1))
	loop(#rest -> size - 1) => {
		#shared = #shared -> intersection(#rest -> get(loop_count + 1))
	}
	return #shared -> join('/')
}

stdoutnl(commonpath(#path1, #path2, #path3))
