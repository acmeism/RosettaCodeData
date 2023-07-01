import java.util.regex.Matcher;
import java.util.regex.Pattern;
...
/* group capturing example */
Pattern pattern = Pattern.compile("(?:(https?)://)?([^/]+)/(?:([^#]+)(?:#(.+))?)?");
Matcher matcher = pattern.matcher("https://rosettacode.org/wiki/Regular_expressions#Java");
if (matcher.find()) {
    String protocol = matcher.group(1);
    String authority = matcher.group(2);
    String path = matcher.group(3);
    String fragment = matcher.group(4);
}
