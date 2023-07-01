local(start = micros)
loop(100000) => {
	'nothing is outout because no autocollect'
}
'time for 100,000 loop repititions: '+(micros - #start)+' microseconds'
