##
uses System.Net;

var wc := new WebClient();
var content := wc.DownloadString('http://example.com');
content.Println
