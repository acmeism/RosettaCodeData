public static String Substring(String str, int n, int m){
    return str.substring(n, n+m);
}
public static String Substring(String str, int n){
    return str.substring(n);
}
public static String Substring(String str){
    return str.substring(0, str.length()-1);
}
public static String Substring(String str, char c, int m){
    return str.substring(str.indexOf(c), str.indexOf(c)+m+1);
}
public static String Substring(String str, String sub, int m){
    return str.substring(str.indexOf(sub), str.indexOf(sub)+m+1);
}
