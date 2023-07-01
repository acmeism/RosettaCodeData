public static void main(){
        System.out.println(isISBN13("978-1734314502"));
        System.out.println(isISBN13("978-1734314509"));
        System.out.println(isISBN13("978-1788399081"));
        System.out.println(isISBN13("978-1788399083"));
    }
public static boolean isISBN13(String in){
        int pre = Integer.parseInt(in.substring(0,3));
        if (pre!=978)return false;
        String postStr = in.substring(4);
        if (postStr.length()!=10)return false;
        int post = Integer.parseInt(postStr);
        int sum = 38;
        for(int x = 0; x<10;x+=2)
        sum += (postStr.charAt(x)-48)*3 + ((postStr.charAt(x+1)-48));
        if(sum%10==0) return true;
        return false;
    }
