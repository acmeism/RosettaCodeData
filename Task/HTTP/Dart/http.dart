import 'dart:io';
void main(){
  var url = 'http://rosettacode.org';
  var client = new HttpClient();
  client.getUrl(Uri.parse(url))
        .then((HttpClientRequest request)   => request.close())
        .then((HttpClientResponse response) => response.pipe(stdout));
}
