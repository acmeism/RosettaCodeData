public static int findNumOfDec(double x){
    String str = String.valueOf(x);
    if(str.endsWith(".0")) return 0;
    else return (str.substring(str.indexOf('.')).length() - 1);
}
