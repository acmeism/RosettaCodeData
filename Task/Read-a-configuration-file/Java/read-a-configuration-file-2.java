import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.util.Arrays;
import java.util.HashMap;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.stream.Collectors;

public class ConfigReader {
    private static final Pattern LINE_PATTERN = Pattern.compile("([^ =]+)[ =]?(.*)");

    public static void main(final String[] args) throws IOException {
        System.out.println(parseFile(args[0]));
    }

    public static Map<String, Object> parseFile(final String fileName) throws IOException {
        final Map<String, Object> result = new HashMap<>();
        result.put("needspeeling", false);
        result.put("seedsremoved", false);
        try (BufferedReader reader = new BufferedReader(new FileReader(fileName))) {
            result.putAll(reader.lines()
                .filter(line -> !"".equals(line.trim()) && !line.startsWith("#") && !line.startsWith(";"))
                .map(LINE_PATTERN::matcher)
                .filter(Matcher::matches)
                .collect(Collectors.toMap(matcher -> matcher.group(1).trim().toLowerCase(), matcher -> {
                    final String value = matcher.group(2).trim();
                    if ("".equals(value)) {
                        return true;
                    } else if (-1 == value.indexOf(',')) {
                        return value;
                    }
                    return Arrays.asList(value.split(",")).stream().map(String::trim).collect(Collectors.toList());
                }))
            );
        }

        return result;
    }
}
