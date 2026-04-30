#!/usr/bin/env raku

use HTTP::UserAgent;
use URI::Escape;
use JSON::Fast;
use Sort::Naturally;

#| This script checks for unimplemented tasks in a given programming language on Rosetta Code.
sub MAIN( Str :$lang = 'Raku' ) {
	my (@total, @implemented);

	@total.append: .&get-cat for 'Programming_Tasks', 'Draft_Programming_Tasks';
	@implemented = get-cat $lang;

	my @unimplemented = (@total (-) @implemented).keys.sort: *.&naturally;
	
	say "Unimplemented tasks in $lang:";
	.say for @unimplemented;
	say "{+@unimplemented} unimplemented tasks";
}


sub get-cat($category) {
	
	my $site = 'https://rosettacode.org/w';
	my $client = HTTP::UserAgent.new(
		useragent => "RosettaCode Unimplemented Tasks Checker - Raku Language Version/1.0"
	);

	flat mediawiki-query(
			$client, $site, 'pages',
			:generator<categorymembers>,
			:gcmtitle("Category:$category"),
			:gcmlimit<350>,
			:rawcontinue(),
		).map({ .<title> });
}

sub mediawiki-query($client, $site, $type, *%query) {

	my $url = "$site/api.php?" ~ uri-query-string(:action<query>, :format<json>, :formatversion<2>, |%query);
    my $continue = '';

    gather loop {
        my $response = $client.get("$url&$continue");
		my $data = from-json($response.content);
        take $_ for $data.<query>.{$type}.values;

		$continue = uri-query-string |($data.<query-continue>{*}».hash.hash or last);
    }
}

sub uri-query-string(*%fields) {
	%fields.map({ "{.key}={uri-escape .value}" }).join("&")
}
