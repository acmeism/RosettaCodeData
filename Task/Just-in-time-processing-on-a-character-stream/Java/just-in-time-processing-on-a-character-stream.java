import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.List;
import java.util.function.Predicate;

public class Processing {
    private static class UserInput {
        private char formFeed;
        private char lineFeed;
        private char tab;
        private char space;

        private UserInput(char formFeed, char lineFeed, char tab, char space) {
            this.formFeed = formFeed;
            this.lineFeed = lineFeed;
            this.tab = tab;
            this.space = space;
        }

        char getFormFeed() {
            return formFeed;
        }

        char getLineFeed() {
            return lineFeed;
        }

        char getTab() {
            return tab;
        }

        char getSpace() {
            return space;
        }
    }

    private static List<UserInput> getUserInput() {
        String h = "0 18 0 0 0 68 0 1 0 100 0 32 0 114 0 45 0 38 0 26 0 16 0 21 0 17 0 59 0 11 " +
            "0 29 0 102 0 0 0 10 0 50 0 39 0 42 0 33 0 50 0 46 0 54 0 76 0 47 0 84 2 28";
        String[] s = h.split(" ");

        List<UserInput> uiList = new ArrayList<>();
        for (int idx = 0; idx + 3 < s.length; idx += 4) {
            char c0 = (char) Integer.parseInt(s[idx + 0]);
            char c1 = (char) Integer.parseInt(s[idx + 1]);
            char c2 = (char) Integer.parseInt(s[idx + 2]);
            char c3 = (char) Integer.parseInt(s[idx + 3]);

            UserInput userInput = new UserInput(c0, c1, c2, c3);
            uiList.add(userInput);
        }
        return uiList;
    }

    private static void decode(String fileName, List<UserInput> uiList) throws IOException {
        Path path = Paths.get(fileName);
        byte[] bytes = Files.readAllBytes(path);
        String text = new String(bytes, StandardCharsets.UTF_8);

        Predicate<UserInput> decode2 = (UserInput ui) -> {
            char f = 0;
            char l = 0;
            char t = 0;
            char s = 0;
            char ff = ui.getFormFeed();
            char lf = ui.getLineFeed();
            char tb = ui.getTab();
            char sp = ui.getSpace();

            for (char c : text.toCharArray()) {
                if (f == ff && l == lf && t == tb && s == sp) {
                    if (c == '!') {
                        return false;
                    }
                    System.out.print(c);
                    return true;
                }
                switch (c) {
                    case '\u000c':
                        f++;
                        l = 0;
                        t = 0;
                        s = 0;
                        break;
                    case '\n':
                        l++;
                        t = 0;
                        s = 0;
                        break;
                    case '\t':
                        t++;
                        s = 0;
                        break;
                    default:
                        s++;
                        break;
                }
            }

            return false;
        };

        for (UserInput ui : uiList) {
            if (!decode2.test(ui)) {
                break;
            }
        }
        System.out.println();
    }

    public static void main(String[] args) throws IOException {
        List<UserInput> uiList = getUserInput();
        decode("theRaven.txt", uiList);
    }
}
