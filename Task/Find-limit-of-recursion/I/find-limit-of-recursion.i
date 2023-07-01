function test(counter) {
	print(counter)
	test(counter+1)
}

software {
	test(0)
}
