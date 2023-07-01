use 5.10.0;
use CGI;

my $s = 'http://foo/bar/';
say $s = CGI::escape($s);
say $s = CGI::unescape($s);
