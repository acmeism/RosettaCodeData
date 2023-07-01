public class ReverseWords {

    static final String[] lines = {
        " ----------- Ice and Fire ----------- ",
        "                                      ",
        " fire, in end will world the say Some ",
        " ice. in say Some                     ",
        " desire of tasted I've what From      ",
        " fire. favor who those with hold I    ",
        "                                      ",
        " ... elided paragraph last ...        ",
        " Frost Robert ----------------------- "};

    public static void main(String[] args) {
        for (String line : lines) {
            String[] words = line.split("\\s");
            for (int i = words.length - 1; i >= 0; i--)
                System.out.printf("%s ", words[i]);
            System.out.println();
        }
    }
}
