USING: base64 http.client io kernel strings ;

"http://rosettacode.org/favicon.ico" http-get nip
>base64-lines >string print
