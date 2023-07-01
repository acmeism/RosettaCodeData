#!/usr/bin/lasso9

handle_error => {
	stdoutnl('There was an error ' + error_msg)
	abort
}

stdoutnl('Starting execution')

0/0

stdoutnl('Ending execution')
