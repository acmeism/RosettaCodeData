package require Tcl 8.6
package require http

set tok [http::geturl http://rosettacode.org/favicon.ico]
set icondata [http::data $tok]
http::cleanup $tok

puts [binary encode base64 -maxlen 64 $icondata]
