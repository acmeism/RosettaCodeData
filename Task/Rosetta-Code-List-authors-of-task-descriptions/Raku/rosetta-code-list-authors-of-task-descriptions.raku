use HTTP::UserAgent;
use URI::Escape;
use JSON::Fast;
use Sort::Naturally;

# Friendlier descriptions for task categories
my %cat = (
    'Programming_Tasks' => 'Task',
    'Draft_Programming_Tasks' => 'Draft'
);

my $client = HTTP::UserAgent.new(:useragent('Rosetta Code Task bot'));

my $url = 'https://rosettacode.org/w';

my $tablefile = './RC_Authors.txt';
my $hashfile  = './RC_Authors.json';

my %tasks;

# clear screen
run($*DISTRO.is-win ?? 'cls' !! 'clear');

%tasks = $hashfile.IO.e ?? $hashfile.IO.slurp.&from-json !! ( );
sleep 1;

#=begin update

note 'Retrieving task information...';

my %filter;
for %cat.keys.sort -> $category {
    mediawiki-query(
        $url, 'pages',
        :generator<categorymembers>,
        :gcmtitle("Category:$category"),
        :gcmlimit<350>,
        :rawcontinue(),
        :prop<title>
    ).map( { %filter{.<title>} = %cat{$category} } )
}

my $delete = %tasks.keys (-) %filter.keys;

%tasks.delete($_) for $delete.keys; #Tasks that have changed names or been removed

my @add;
for %filter.keys -> $title {
    if %tasks{$title}:exists {
        %tasks{$title}<category> = %filter{$title} # update status
    } else {
        @add.push: $title => %filter{$title} # New Tasks
    }
}

if @add {
    .say for 'Adding new tasks:', |@add;
}

for @add -> $task {
    mediawiki-query(
        $url, 'pages',
        :titles($task.key),
        :prop<revisions>,
        :rvprop<user|timestamp>,
        :rvstart<2000-01-01T01:01:01Z>,
        :rvdir<newer>,
        :rvlimit<1>
    ).map: {
        print clear, 1 + $++, ' ', .[0]<title>;
        %tasks{.[0]<title>}<category> = $task.value;
        %tasks{.[0]<title>}<author> = .[0]<revisions>[0]<user>;
        %tasks{.[0]<title>}<date> = .[0]<revisions>[0]<timestamp>.subst(/'T'.+$/, '')
    }
}

print clear;

# Save information to a local file
note "\nTask information saved to local file: {$hashfile.IO.absolute}";
$hashfile.IO.spurt(%tasks.&to-json);

#=end update

# Load information from local file
%tasks = $hashfile.IO.e ?? $hashfile.IO.slurp.&from-json !! ( );

# Convert saved task / author info to a table
note "\nBuilding table...";
my $count    = +%tasks;
my $taskcnt  = +%tasks.grep: *.value.<category> eq %cat<Programming_Tasks>;
my $draftcnt = $count - $taskcnt;

# Open a file handle to dump table in
my $out = open($tablefile, :w)  or die "$!\n";

# Add table boilerplate and header
$out.say:
    "\{|class=\"wikitable sortable\"\n",
    "|+ As of { Date.today } :: Total Tasks: { $count }:: Tasks: { $taskcnt }",
    " ::<span style=\"background-color:#ffd\"> Draft Tasks: { $draftcnt } </span>",
    ":: By {+%tasks{*}».<author>.unique} Authors\n",
    "! Author !! Tasks !! Authored"
;

# Get sorted unique list of task authors
for %tasks{*}».<author>.unique.sort(&naturally) -> $author {

    # Get list of tasks by this author
    my @these = %tasks.grep( { $_.value.<author> eq $author } );
    my $s = +@these == 1 ?? '' !! 's';

    # Add author and contributions link to the first two cells
    $out.say:
    $author ~~ /\d/
      ?? "|- id=\"$author\"\n|data-sort-value=\"{ sort-key $author }\"|[[User:$author|$author]]\n"~
         "|data-sort-value=\"{ +@these }\"|[[Special:Contributions/$author|"~
         "{ +@these } task{ $s }]]"
      !! "|- id=\"$author\"\n|[[User:$author|$author]]\n"~
         "|data-sort-value=\"{ +@these }\"|[[Special:Contributions/$author|"~
         "{ +@these } task{ $s }]]"
    ;

    if +@these > 2 {
        $out.say: "|style=\"padding: 0px;\"|\n",
          "\{|class=\"broadtable sortable\" style=\"width: 100%;\"\n",
          "! Task Name !! Date Added !! Status";
    }
    else {
        $out.say: "|style=\"padding: 0px;\"|\n",
          "\{|class=\"broadtable\" style=\"width: 100%;\"";
   }

    # Tasks by this author, sorted by name
    for @these.sort({.key.&naturally}) -> $task {

        my $color = $task.value.<category> eq 'Draft' ?? '#ffd' !! '#fff';

        # add the task link, date and status to the table in the second cell
        $out.say: "|-\n|style=\"background-color: $color;\"",
          ( $task.key ~~ /\d/
            ?? " data-sort-value=\"{ sort-key $task.key }\"| [[{uri-escape $task.key}|{$task.key}]]\n"
            !! "| [[{uri-escape $task.key}|{$task.key}]]\n"
          ),
          "|style=\"width: 10em; background-color: $color;\"| {$task.value.<date>}\n",
          "|style=\"width: 6em; background-color: $color;\"| {$task.value.<category>}",
    }
     $out.say: '|}'
}
$out.say( "|}\n" );
$out.close;


note "Table file saved as: {$tablefile.IO.absolute}";

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

sub uri-query-string (*%fields) { %fields.map({ "{.key}={uri-escape .value}" }).join("&") }

sub sort-key ($a) { $a.lc.subst(/(\d+)/, ->$/ {0~(65+($0.chars)).chr~$0},:g) }

sub clear { "\r" ~ ' ' x 100 ~ "\r" }
