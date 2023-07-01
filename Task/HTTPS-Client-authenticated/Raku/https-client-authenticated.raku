# cert creation commands

# openssl req -newkey rsa:4096 -keyout my_key.pem -out my_csr.pem -nodes -subj "/CN=ME"

# openssl x509 -req -in my_csr.pem -signkey my_key.pem -out my_cert.pem

use v6;
use OpenSSL;

my $host = "github.com";

my $ssl = OpenSSL.new(:client);

$ssl.use-certificate-file("./my_cert.pem");
$ssl.use-privatekey-file("./my_key.pem");
$ssl.check-private-key;


my $s = IO::Socket::INET.new(:$host, :port(443));

$ssl.set-socket($s);
$ssl.set-connect-state;
$ssl.connect;
$ssl.write("GET / HTTP/1.1\r\n\r\n");
say $ssl.read(1024);
$ssl.close;
$s.close;
