import std.stdio;

dstring input =
    "Character,Speech\n"
    "The multitude,The messiah! Show us the messiah!\n"
    "Brians mother,<angry>Now you listen here! He's not the messiah; "
        "he's a very naughty boy! Now go away!</angry>\n"
    "The multitude,Who are you?\n"
    "Brians mother,I'm his mother; that's who!\n"
    "The multitude,Behold his mother! Behold his mother!";

void main() {
    bool theadDone;
    write("<html>\n<head><meta charset=\"utf-8\"></head>\n<body>\n\n");
    write("<table border=\"1\" cellpadding=\"5\" cellspacing=\"0\">\n<thead>\n  <tr><td>");
    foreach (c; input) {
        switch(c) {
            case '\n':
                if (theadDone)
                    write("</td></tr>\n  <tr><td>");
                else {
                    write("</td></tr>\n</thead>\n<tbody>\n  <tr><td>");
                    theadDone = true;
                }
                break;
            case ',':  write("</td><td>"); break;
            case '<':  write("&lt;"); break;
            case '>':  write("&gt;"); break;
            case '&':  write("&amp;"); break;
            default:   write(c);
        }
    }
    write("</td></tr>\n</tbody>\n</table>\n\n</body></html>");
}
