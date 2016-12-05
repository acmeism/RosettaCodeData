local(
	path	= file_forceroot,
	ls	= sys_process('/bin/ls', (:'-l', #path)),
	lswait	= #ls -> wait
)
'<pre>'
#ls -> read
'</pre>'
