import groovy.transform.TailRecursive
import static java.lang.Math.min

@TailRecursive
String wordWrap(str, w, i=w, b=''<<'', len=str.length()-1, x=0) {
  b.setCharAt(x = (b << str[b.length()..i]).lastIndexOf(' '), '\n' as char)
  b.length()+w >= len ? b << str[i..-1] : wordWrap(str, w, min(x+w+1, len), b, len, 0)
}
