import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.atomic.AtomicReference;
import java.util.function.Predicate;
import java.util.regex.Pattern;
import java.util.stream.Collectors;

public class FindBareTags {
    private static final String BASE = "http://rosettacode.org";

    private static final Pattern TITLE_PATTERN = Pattern.compile("\"title\": \"([^\"]+)\"");
    private static final Pattern HEADER_PATTERN = Pattern.compile("==\\{\\{header\\|([^}]+)}}==");
    private static final Predicate<String> BARE_PREDICATE = Pattern.compile("<lang>").asPredicate();

    public static void main(String[] args) throws Exception {
        var client = HttpClient.newBuilder().build();

        URI titleUri = URI.create(BASE + "/mw/api.php?action=query&list=categorymembers&cmtitle=Category:Programming_Tasks");
        var titleRequest = HttpRequest.newBuilder(titleUri).GET().build();

        var titleResponse = client.send(titleRequest, HttpResponse.BodyHandlers.ofString());
        if (titleResponse.statusCode() == 200) {
            var titleBody = titleResponse.body();

            var titleMatcher = TITLE_PATTERN.matcher(titleBody);
            var titleList = titleMatcher.results().map(mr -> mr.group(1)).collect(Collectors.toList());

            var countMap = new HashMap<String, Integer>();
            for (String title : titleList) {
                var pageUri = new URI("http", null, "//rosettacode.org/wiki", "action=raw&title=" + title, null);
                var pageRequest = HttpRequest.newBuilder(pageUri).GET().build();
                var pageResponse = client.send(pageRequest, HttpResponse.BodyHandlers.ofString());
                if (pageResponse.statusCode() == 200) {
                    var pageBody = pageResponse.body();

                    AtomicReference<String> language = new AtomicReference<>("no language");
                    pageBody.lines().forEach(line -> {
                        var headerMatcher = HEADER_PATTERN.matcher(line);
                        if (headerMatcher.matches()) {
                            language.set(headerMatcher.group(1));
                        } else if (BARE_PREDICATE.test(line)) {
                            int count = countMap.getOrDefault(language.get(), 0) + 1;
                            countMap.put(language.get(), count);
                        }
                    });
                } else {
                    System.out.printf("Got a %d status code%n", pageResponse.statusCode());
                }
            }

            for (Map.Entry<String, Integer> entry : countMap.entrySet()) {
                System.out.printf("%d in %s%n", entry.getValue(), entry.getKey());
            }
        } else {
            System.out.printf("Got a %d status code%n", titleResponse.statusCode());
        }
    }
}
