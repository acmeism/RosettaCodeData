use Net::FTP;

# set server and credentials
my $host     = 'speedtest.tele2.net';
my $user     = 'anonymous';
my $password = '';

# connect in passive mode
my $f = Net::FTP->new($host) or die "Can't open $host\n";
$f->login($user, $password)  or die "Can't login as $user\n";
$f->passive();

# change remote directory, list contents
$f->cwd('upload');
@files = $f->ls();
printf "Currently %d files in the 'upload' directory.\n", @files;

# download file in binary mode
$f->cwd('/');
$f->type('binary');
$local = $f->get('512KB.zip');
print "Your file was stored as $local in the current directory\n";
