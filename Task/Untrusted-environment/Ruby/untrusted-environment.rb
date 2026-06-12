require 'cgi'
$SAFE = 4
cgi = CGI::new("html4")
eval(cgi["arbitrary_input"].to_s)
