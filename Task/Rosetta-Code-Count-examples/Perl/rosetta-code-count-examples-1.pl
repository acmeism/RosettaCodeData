use LWP::Simple;

my $site = "http://rosettacode.org";
my $list_url = "/mw/api.php?action=query&list=categorymembers&cmtitle=Category:Programming_Tasks&cmlimit=500&format=xml";

for (get("$site$list_url") =~ /cm.*?title="(.*?)"/g) {
    (my $slug = $_) =~ tr/ /_/;
    my $count = () = get("$site/wiki/$slug") =~ /toclevel-1/g;
    print "$_: $count examples\n";
}
