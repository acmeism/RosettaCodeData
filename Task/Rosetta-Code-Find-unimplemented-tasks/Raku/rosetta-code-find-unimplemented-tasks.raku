#!/usr/bin/env raku

use HTTP::UserAgent;
use URI::Escape;
use JSON::Fast;
use Sort::Naturally;

#| This script checks for unimplemented tasks in a given programming language on Rosetta Code.
sub MAIN( Str :$lang = 'Raku' ) {
	my (@total, @implemented, @unimplemented);

	@total.append: .&get-tasks for 'Programming_Tasks', 'Draft_Programming_Tasks';
	
	@implemented = get-tasks $lang;

	@unimplemented = (@total (-) @implemented).keys;
	
	pretty-print($lang, @total.elems, @unimplemented);
}

sub pretty-print($lang, $total, @unimplemented) {
	my $msg = "For $lang {@unimplemented.elems} out of $total tasks are not yet implemented:";
	say $msg;
	say "-" x $msg.chars;
	for @tasks.sort({ .&naturally }).kv -> $index, $task {
		my $display = $task.substr(0, $task.chars min 60);
		say "$index\t" ~ $display ~ ( $task.chars > 60 ?? "..." !! "" );
	}
}

sub get-tasks($category) {
	
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

	my $url = "$site/api.php?" ~ uri-query-string(:action<query>,
												  :format<json>,
												  :formatversion<2>, |%query);
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
