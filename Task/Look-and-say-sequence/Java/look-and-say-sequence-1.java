public static String lookandsay(String number){
	StringBuilder result= new StringBuilder();

	char repeat= number.charAt(0);
	number= number.substring(1) + " ";
	int times= 1;

	for(char actual: number.toCharArray()){
		if(actual != repeat){
			result.append(times + "" + repeat);
			times= 1;
			repeat= actual;
		}else{
			times+= 1;
		}
	}
	return result.toString();
}
