public static boolean pali(String testMe){
	StringBuilder sb = new StringBuilder(testMe);
	return testMe.equalsIgnoreCase(sb.reverse().toString());
}
