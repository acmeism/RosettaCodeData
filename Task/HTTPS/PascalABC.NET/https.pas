##
uses System.Net;

var wc := new WebClient();
var content := wc.DownloadString('https://example.com');
content.Println
