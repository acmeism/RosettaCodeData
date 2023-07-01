#!/usr/bin/lasso9

local(lockfile = file('/tmp/myprocess.lockfile'))

if(#lockfile -> exists) => {
	stdoutnl('Error: App is running as of ' + #lockfile -> readstring)
	abort
}

handle => {
	#lockfile -> delete
}

stdoutnl('Starting execution')

#lockfile -> doWithClose => {
	#lockfile -> writebytes(bytes(date))
}

sleep(10000)

stdoutnl('Execution done')
