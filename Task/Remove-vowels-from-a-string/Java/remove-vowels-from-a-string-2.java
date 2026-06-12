public static String removeVowelse(String str){
    String re = "";
    char c;
    for(int x = 0; x<str.length(); x++){
        c = str.charAt(x);
        if(!(c=='a'||c=='e'||c=='i'||c=='o'||c=='u'))
        re+=c;
    }
    return re;
}
