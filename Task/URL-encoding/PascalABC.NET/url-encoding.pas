##
function URLEncode(s: string) := System.Uri.EscapeDataString(s);

Println(URLEncode('http://foo bar/'));
