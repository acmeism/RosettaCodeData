use Net::FTP;

my $host = 'speedtest.tele2.net';
my $user = 'anonymous';
my $password = '';

my $ftp = Net::FTP.new( host => $host, :passive );

$ftp.login( user => $user, pass => $password );

$ftp.cwd( 'upload' );

$ftp.cwd( '/' );

say $_<name> for $ftp.ls;

$ftp.get( '1KB.zip', :binary );
