public static boolean rPali(String testMe){
	int strLen = testMe.length();
	return rPaliHelp(testMe, strLen-1, strLen/2, 0);
}

public static boolean rPaliHelp(String testMe, int strLen, int testLen, int index){
	if(index > testLen){
		return true;
	}
	if(testMe.charAt(index) != testMe.charAt(strLen-index)){
		return false;
	}
	return rPaliHelp(testMe, strLen, testLen, index + 1);
}
