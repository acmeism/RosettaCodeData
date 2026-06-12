# 20200821 added Perl programming solution

use strict;
use warnings;

use Regexp::Common qw /URI/; # https://metacpan.org/pod/Regexp::Common::URI

while ( my $line = <DATA> ) {
   chomp $line;
   my @URIs = $line =~ /$RE{URI}/g and print "URI(s) found.\n";
   foreach my $uri (@URIs) { print "URI : $uri\n" }
}

__DATA__
this URI contains an illegal character, parentheses and a misplaced full stop:
http://en.wikipedia.org/wiki/Erich_Kästner_(camera_designer). (which is handled by http://mediawiki.org/).
and another one just to confuse the parser: http://en.wikipedia.org/wiki/-)
")" is handled the wrong way by the mediawiki parser.
ftp://domain.name/path(balanced_brackets)/foo.html
ftp://domain.name/path(balanced_brackets)/ending.in.dot.
ftp://domain.name/path(unbalanced_brackets/ending.in.dot.
leading junk ftp://domain.name/path/embedded?punct/uation.
leading junk ftp://domain.name/dangling_close_paren)
