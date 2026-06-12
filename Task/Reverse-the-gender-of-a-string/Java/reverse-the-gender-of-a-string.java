public class ReallyLameTranslationOfJ {

    public static void main(String[] args) {
        String s = "She was a soul stripper. She took my heart!";
        System.out.println(cheapTrick(s));
        System.out.println(cheapTrick(cheapTrick(s)));
    }

    static String cheapTrick(String s) {
        if (s.contains("She"))
            return s.replaceAll("She", "He");
        else if(s.contains("He"))
            return s.replaceAll("He", "She");
        return s;
    }
}
