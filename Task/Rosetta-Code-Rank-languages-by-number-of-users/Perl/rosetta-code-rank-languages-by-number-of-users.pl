use strict;
use warnings;
use JSON;
use URI::Escape;
use LWP::UserAgent;

my $client = LWP::UserAgent->new;
$client->agent("Rosettacode Perl task solver");
my $url = 'http://rosettacode.org/mw';
my $minimum = 100;

sub uri_query_string {
    my(%fields) = @_;
    'action=query&format=json&formatversion=2&' .
    join '&', map { $_ . '=' . uri_escape($fields{$_}) } keys %fields
}

sub mediawiki_query {
    my($site, $type, %query) = @_;
    my $url = "$site/api.php?" . uri_query_string(%query);
    my %languages = ();

    my $req = HTTP::Request->new( GET => $url );
    my $response = $client->request($req);
    $response->is_success or die "Failed to GET '$url': ", $response->status_line;
    my $data = decode_json($response->content);
    for my $row ( @{${$data}{query}{pages}} ) {
        next unless defined $$row{categoryinfo} && $$row{title} =~ /User/;
        my($title) = $$row{title} =~ /Category:(.*?) User/;
        my($count) = $$row{categoryinfo}{pages};
        $languages{$title} = $count;
    }
    %languages;
}

my %table = mediawiki_query(
    $url, 'pages',
    ( generator   => 'categorymembers',
      gcmtitle    => 'Category:Language users',
      gcmlimit    => '999',
      prop        => 'categoryinfo',
      rawcontinue => '',
    )
);

for my $k (sort { $table{$b} <=> $table{$a} } keys %table) {
    printf "%4d %s\n", $table{$k}, $k if $table{$k} > $minimum;
}
