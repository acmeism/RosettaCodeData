my $host = '127.0.0.1';
my $port = 256;

my $client = IO::Socket::INET.new(:$host, :$port);
$client.print( 'hello socket world' );
$client.close;
