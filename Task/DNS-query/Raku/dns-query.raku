use Net::DNS;

my $resolver = Net::DNS.new('8.8.8.8');

my $ip4 = $resolver.lookup('A',    'orange.kame.net');
my $ip6 = $resolver.lookup('AAAA', 'orange.kame.net');

say $ip4[0].octets.join: '.';
say $ip6[0].octets.».fmt("%.2X").join.comb(4).join: ':';
