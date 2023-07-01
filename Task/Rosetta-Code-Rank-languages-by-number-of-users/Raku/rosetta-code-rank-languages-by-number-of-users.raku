use HTTP::UserAgent;
use URI::Escape;
use JSON::Fast;

my $client = HTTP::UserAgent.new;

my $url = 'https://rosettacode.org/w';

my $start-time = now;

say "========= Generated: { DateTime.new(time) } =========";

my $lang = 1;
my $rank = 0;
my $last = 0;
my $tie = ' ';
my $minimum = 25;

.say for
    mediawiki-query(
        $url, 'pages',
        :generator<categorymembers>,
        :gcmtitle<Category:Language users>,
        :gcmlimit<350>,
        :rawcontinue(),
        :prop<categoryinfo>
    )

    .map({ %( count => .<categoryinfo><pages> || 0,
              lang  => .<title>.subst(/^'Category:' (.+) ' User'/, ->$/ {$0}) ) })

    .sort( { -.<count>, .<syntaxhighlight lang="text"> } )

    .map( { last if .<count> < $minimum; display(.<count>, .<syntaxhighlight lang="text">) } );

say "========= elapsed: {(now - $start-time).round(.01)} seconds =========";

sub display ($count, $which) {
    if $last != $count { $last = $count; $rank = $lang; $tie = ' ' } else { $tie = 'T' };
    sprintf "#%3d  Rank: %2d %s  with %-4s users:  %s", $lang++, $rank, $tie, $count, $which;
}

sub mediawiki-query ($site, $type, *%query) {
    my $url = "$site/api.php?" ~ uri-query-string(
        :action<query>, :format<json>, :formatversion<2>, |%query);
    my $continue = '';

    gather loop {
        my $response = $client.get("$url&$continue");
        my $data = from-json($response.content);
        take $_ for $data.<query>.{$type}.values;
        $continue = uri-query-string |($data.<query-continue>{*}».hash.hash or last);
    }
}

sub uri-query-string (*%fields) {
    join '&', %fields.map: { "{.key}={uri-escape .value}" }
}
