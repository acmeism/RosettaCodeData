##
uses System.Net;

var wc := new WebClient();
wc.Credentials := new NetworkCredential('admin', 'admin');
var content := wc.DownloadString('https://httpbin.org/basic-auth/admin/admin');
content.Println
