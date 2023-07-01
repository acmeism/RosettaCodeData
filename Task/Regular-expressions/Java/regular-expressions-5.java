import java.util.regex.*;
Pattern p = Pattern.compile("a*b");
Matcher m = p.matcher(str);
while (m.find()) {
  // use m.group() to extract matches
}
