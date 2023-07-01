string icon = Protocols.HTTP.get_url_data("http://rosettacode.org/favicon.ico");
string encoded = MIME.encode_base64(icon);
Stdio.write_file("favicon.ico", MIME.decode_base64(encoded));
