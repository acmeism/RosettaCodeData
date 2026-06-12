import java.io.IOException;
import java.net.URI;
import java.net.URISyntaxException;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.time.Duration;
import java.util.ArrayList;
import java.util.regex.Pattern;

public class TasksWithoutExamples {
    private static String readPage(HttpClient client, URI uri) throws IOException, InterruptedException {
        var request = HttpRequest.newBuilder()
            .GET()
            .uri(uri)
            .timeout(Duration.ofSeconds(5))
            .setHeader("accept", "text/html")
            .build();

        var response = client.send(request, HttpResponse.BodyHandlers.ofString());
        return response.body();
    }

    private static void process(HttpClient client, String base, String task) {
        try {
            var re = Pattern.compile(".*using any language you may know.</div>(.*?)<div id=\"toc\".*", Pattern.DOTALL + Pattern.MULTILINE);
            var re2 = Pattern.compile("</?[^>]*>");

            var page = base + task;
            String body = readPage(client, new URI(page));

            var matcher = re.matcher(body);
            if (matcher.matches()) {
                var group = matcher.group(1);
                var m2 = re2.matcher(group);
                var text = m2.replaceAll("");
                System.out.println(text);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public static void main(String[] args) throws URISyntaxException, IOException, InterruptedException {
        var re = Pattern.compile("<li><a href=\"/wiki/(.*?)\"", Pattern.DOTALL + Pattern.MULTILINE);

        var client = HttpClient.newBuilder()
            .version(HttpClient.Version.HTTP_1_1)
            .followRedirects(HttpClient.Redirect.NORMAL)
            .connectTimeout(Duration.ofSeconds(5))
            .build();

        var uri = new URI("http", "rosettacode.org", "/wiki/Category:Programming_Tasks", "");
        var body = readPage(client, uri);
        var matcher = re.matcher(body);

        var tasks = new ArrayList<String>();
        while (matcher.find()) {
            tasks.add(matcher.group(1));
        }

        var base = "http://rosettacode.org/wiki/";
        var limit = 3L;

        tasks.stream().limit(limit).forEach(task -> process(client, base, task));
    }
}
