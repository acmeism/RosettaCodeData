use feature 'say';
use Socket qw(getaddrinfo getnameinfo);

my ($err, @res) = getaddrinfo('orange.kame.net', 0, { protocol=>Socket::IPPROTO_TCP } );
die "getaddrinfo error: $err" if $err;

say ((getnameinfo($_->{addr}, Socket::NI_NUMERICHOST))[1]) for @res
