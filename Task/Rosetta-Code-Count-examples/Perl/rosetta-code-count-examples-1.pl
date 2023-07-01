use HTTP::Tiny;

my $site = "http://rosettacode.org";
my $list_url = "/w/api.php?action=query&list=categorymembers&cmtitle=Category:Programming_Tasks&cmlimit=500&format=xml";

my $response = HTTP::Tiny->new->get("$site$list_url");
for ($response->{content} =~ /cm.*?title="(.*?)"/g) {
    (my $slug = $_) =~ tr/ /_/;
    my $response = HTTP::Tiny->new->get("$site/wiki/$slug");
    my $count = () = $response->{content} =~ /toclevel-1/g;
    print "$_: $count examples\n";
}
