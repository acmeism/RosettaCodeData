my $host = '127.0.0.1';
my $port = 256;

my $client = IO::Socket::INET.new(:$host, :$port);
$client.send( 'hello socket world' );
$client.close;
