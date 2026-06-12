package require base64
package require http

set tok [http::geturl http://rosettacode.org/favicon.ico]
set icondata [http::data $tok]
http::cleanup $tok

puts [base64::encode -maxlen 64 $icondata]
