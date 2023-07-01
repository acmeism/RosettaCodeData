import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.stream.Collectors;

public class WordCount {
    public static void main(String[] args) throws IOException {
        Path path = Paths.get("135-0.txt");
        byte[] bytes = Files.readAllBytes(path);
        String text = new String(bytes);
        text = text.toLowerCase();

        Pattern r = Pattern.compile("\\p{javaLowerCase}+");
        Matcher matcher = r.matcher(text);
        Map<String, Integer> freq = new HashMap<>();
        while (matcher.find()) {
            String word = matcher.group();
            Integer current = freq.getOrDefault(word, 0);
            freq.put(word, current + 1);
        }

        List<Map.Entry<String, Integer>> entries = freq.entrySet()
            .stream()
            .sorted((i1, i2) -> Integer.compare(i2.getValue(), i1.getValue()))
            .limit(10)
            .collect(Collectors.toList());

        System.out.println("Rank  Word  Frequency");
        System.out.println("====  ====  =========");
        int rank = 1;
        for (Map.Entry<String, Integer> entry : entries) {
            String word = entry.getKey();
            Integer count = entry.getValue();
            System.out.printf("%2d    %-4s    %5d\n", rank++, word, count);
        }
    }
}
