use v5.10;
use Mojo::UserAgent;

my $site = "http://rosettacode.org";
my $list_url = "/mw/api.php?action=query&list=categorymembers&cmtitle=Category:Programming_Tasks&cmlimit=500&format=xml";

my $ua = Mojo::UserAgent->new;
$ua->get("$site$list_url")->res->dom->find('cm')->each(sub {
    (my $slug = $_->{title}) =~ tr/ /_/;
    my $count = $ua->get("$site/wiki/$slug")->res->dom->find("#toc .toclevel-1")->size;
    say "$_->{title}: $count examples";
});
