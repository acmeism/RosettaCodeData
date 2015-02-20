void main() {
    import std.stdio;

    immutable input =
        "Character,Speech\n" ~
        "The multitude,The messiah! Show us the messiah!\n" ~
        "Brians mother,<angry>Now you listen here! He's not the messiah; " ~
            "he's a very naughty boy! Now go away!</angry>\n" ~
        "The multitude,Who are you?\n" ~
        "Brians mother,I'm his mother; that's who!\n" ~
        "The multitude,Behold his mother! Behold his mother!";

    "<html>\n<head><meta charset=\"utf-8\"></head>\n<body>\n\n".write;
    "<table border=\"1\" cellpadding=\"5\" cellspacing=\"0\">\n<thead>\n  <tr><td>".write;

    bool theadDone = false;

    foreach (immutable c; input) {
        switch(c) {
            case '\n':
                if (theadDone) {
                    "</td></tr>\n  <tr><td>".write;
                } else {
                    "</td></tr>\n</thead>\n<tbody>\n  <tr><td>".write;
                    theadDone = true;
                }
                break;
            case ',':  "</td><td>".write; break;
            case '<':  "&lt;".write;      break;
            case '>':  "&gt;".write;      break;
            case '&':  "&amp;".write;     break;
            default:   c.write;           break;
        }
    }

    "</td></tr>\n</tbody>\n</table>\n\n</body></html>".write;
}
