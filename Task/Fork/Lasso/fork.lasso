local(mydata = 'I am data one')

split_thread => {
	loop(2)	=> {
		sleep(2000)
		stdoutnl(#mydata)
		#mydata = 'Oh, looks like I am in a new thread'
	}
}

loop(2)	=> {
	sleep(3000)
	stdoutnl(#mydata)
	#mydata = 'Aha, I am still in the original thread'
}
