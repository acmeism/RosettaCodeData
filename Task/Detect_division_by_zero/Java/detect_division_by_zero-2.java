public static boolean except(double numer, double denom){
	try{
		int dummy = (int)numer / (int)denom;//ArithmeticException is only thrown from integer math
		return false;
	}catch(ArithmeticException e){return true;}
}
