use 5.010;
use MediaWiki::API;

my $api =
  MediaWiki::API->new( { api_url => 'http://rosettacode.org/w/api.php' } );

my @languages;
my $gcmcontinue;
while (1) {
    my $apih = $api->api(
        {
            action      => 'query',
            generator   => 'categorymembers',
            gcmtitle    => 'Category:Programming Languages',
            gcmlimit    => 250,
            prop        => 'categoryinfo',
            gcmcontinue => $gcmcontinue
        }
    );
    push @languages, values %{ $apih->{'query'}{'pages'} };

    last if not $gcmcontinue = $apih->{'continue'}{'gcmcontinue'};
}

for (@languages) {
    $_->{'title'} =~ s/Category://;
    $_->{'categoryinfo'}{'size'} //= 0;
}

my @sorted_languages =
  reverse sort { $a->{'categoryinfo'}{'size'} <=> $b->{'categoryinfo'}{'size'} }
  @languages;

binmode STDOUT, ':encoding(utf8)';
my $n = 1;
for (@sorted_languages) {
    printf "%3d. %20s - %3d\n", $n++, $_->{'title'},
      $_->{'categoryinfo'}{'size'};
}
