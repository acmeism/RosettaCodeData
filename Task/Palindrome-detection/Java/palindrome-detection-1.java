public static boolean pali(String testMe){
	StringBuilder sb = new StringBuilder(testMe);
	return testMe.equals(sb.reverse().toString());
}
