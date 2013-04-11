public static boolean rPali(String testMe){
	if(testMe.length()<=1){
		return true;
	}
	if(!(testMe.charAt(0)+"").equalsIgnoreCase(testMe.charAt(testMe.length()-1)+"")){
		return false;
	}
	return rPali(testMe.substring(1, testMe.length()-1));
}
