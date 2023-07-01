import java.util.function.Predicate
import java.util.regex.Matcher
import java.util.regex.Pattern

class FindBareTags {
    private static final Pattern TITLE_PATTERN = Pattern.compile("\"title\": \"([^\"]+)\"")
    private static final Pattern HEADER_PATTERN = Pattern.compile("==\\{\\{header\\|([^}]+)}}==")
    private static final Predicate<String> BARE_PREDICATE = Pattern.compile("<lang>").asPredicate()

    static String download(URL target) {
        URLConnection connection = target.openConnection()
        connection.setRequestProperty("User-Agent", "Firefox/2.0.0.4")

        InputStream is = connection.getInputStream()
        return is.getText("UTF-8")
    }

    static void main(String[] args) {
        URI titleUri = URI.create("http://rosettacode.org/mw/api.php?action=query&list=categorymembers&cmtitle=Category:Programming_Tasks")
        String titleText = download(titleUri.toURL())
        if (titleText != null) {
            Matcher titleMatcher = TITLE_PATTERN.matcher(titleText)

            Map<String, Integer> countMap = new HashMap<>()
            while (titleMatcher.find()) {
                String title = titleMatcher.group(1)

                URI pageUri = new URI("http", null, "//rosettacode.org/wiki", "action=raw&title=$title", null)
                String pageText = download(pageUri.toURL())
                if (pageText != null) {
                    String language = "no language"
                    for (String line : pageText.readLines()) {
                        Matcher headerMatcher = HEADER_PATTERN.matcher(line)
                        if (headerMatcher.matches()) {
                            language = headerMatcher.group(1)
                            continue
                        }

                        if (BARE_PREDICATE.test(line)) {
                            int count = countMap.get(language, 0) + 1
                            countMap.put(language, count)
                        }
                    }
                } else {
                    println("Got an error reading the task page")
                }
            }

            for (Map.Entry<String, Integer> entry : countMap.entrySet()) {
                println("$entry.value in $entry.key")
            }
        } else {
            println("Got an error reading the title page")
        }
    }
}
