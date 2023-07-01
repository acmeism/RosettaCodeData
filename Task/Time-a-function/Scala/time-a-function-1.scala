def time(f: => Unit)={
	val s = System.currentTimeMillis
	f
	System.currentTimeMillis - s
}
