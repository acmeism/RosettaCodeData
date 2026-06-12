string icon = Protocols.HTTP.get_url_data("http://rosettacode.org/favicon.ico");
// The default base64 encodeing linefeeds every 76 chars
array encoded_lines = MIME.encode_base64(icon)/"\n";
// For brivety, just print the first and last line
write("%s\n...\n%s\n", encoded_lines[0], encoded_lines[-1]);
