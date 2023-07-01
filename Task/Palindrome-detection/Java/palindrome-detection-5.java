public static boolean pali(String testMe){
	return testMe.matches("|(?:(.)(?<=(?=^.*?(\\1\\2?)$).*))+(?<=(?=^\\2$).*)");
}
