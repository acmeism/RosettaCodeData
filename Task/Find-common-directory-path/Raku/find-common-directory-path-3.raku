my $sep = '/';
my @dirs = </home/user1/tmp/coverage/test
            /home/user1/tmp/covert/operator
            /home/user1/tmp/coven/members>;

sub is_common_prefix { so $^prefix eq all(@dirs).substr(0, $prefix.chars) }

say ([\~] @dirs.comb(/ $sep [ <!before $sep> . ]* /)).reverse.first: &is_common_prefix
