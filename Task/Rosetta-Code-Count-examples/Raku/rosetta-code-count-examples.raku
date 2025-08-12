use HTTP::UserAgent;
use URI::Escape;
use JSON::Fast;
use Lingua::EN::Numbers :short;

unit sub MAIN ( Bool :nf(:$no-fetch) = False, :t(:$tier) = 1 );

# Friendlier descriptions for task categories
my %cat = (
    'Programming_Tasks' => 'Task',
    'Draft_Programming_Tasks' => 'Draft'
);

my $client = HTTP::UserAgent.new(:useragent('Rosetta Code Task bot'));
$client.timeout = 10;

my $url = 'https://rosettacode.org/w';

my $hashfile  = './RC_Task_count.json';
my $tablefile = "./RC_Task_count-{$tier}.txt";

my %tasks;

my @places = <① ② ③ ④ ⑤ ⑥ ⑦ ⑧ ⑨ ⑩ ⑪ ⑫ ⑬ ⑭ ⑮ ⑯ ⑰ ⑱ ⑲ ⑳ ㉑ ㉒ ㉓ ㉔ ㉕
      ㉖ ㉗ ㉘ ㉙ ㉚ ㉛ ㉜ ㉝ ㉞ ㉟ ㊱ ㊲ ㊳ ㊴ ㊵ ㊶ ㊷ ㊸ ㊹ ㊺ ㊺ ㊻ ㊼ ㊽ ㊾ ㊿>;

# clear screen
run($*DISTRO.is-win ?? 'cls' !! 'clear') unless $no-fetch;

my %counts =
    mediawiki-query(
        $url, 'pages',
        :generator<categorymembers>,
        :gcmtitle<Category:Programming Languages>,
        :gcmlimit<350>,
        :rawcontinue(),
        :prop<categoryinfo>
    )
    .map({ .<title>.subst(/^'Category:'/, '') => .<categoryinfo><pages> || 0 });

my $per-tier = 10;

my $which = (^$per-tier) »+» $per-tier * ($tier - 1);

my @top-n = %counts.sort( {-.value, .key} )[|$which].map: *.key.trans(' ' => '_');

# dump a copy to STDOUT, mostly for debugging purposes
say "<pre>{tc $tier.&ord-n} {$per-tier.&card} programming languages by number of task examples completed:";
say '    ', join ' ', .map( {("{(@places[|$which])[$_]} {@top-n[$_]}").fmt("%-15s")} ) for (^@top-n).batch(5);
say "</pre>\n";

unless $no-fetch {

    note 'Retrieving task information...';

    mkdir('./pages') unless './pages'.IO.e;

    @top-n = %counts.sort( {-.value, .key} )[^@places].map: *.key.trans(' ' => '_');;

    for %cat.keys.sort -> $cat {
        mediawiki-query(
            $url, 'pages',
            :generator<categorymembers>,
            :gcmtitle("Category:$cat"),
            :gcmlimit<350>,
            :rawcontinue(),
            :prop<title>
        ).map({
            my $page;
            my $response;

            loop {
                $response = $client.get("{ $url }/index.php?title={ uri-escape .<title> }&action=raw");
                if $response.is-success {
                    $page = $response.content;
                    last;
                } else {
                    redo;
                }
            }

            "./pages/{ uri-escape .<title>.subst(/' '/, '_', :g) }".IO.spurt($page);
            my $lc = $page.lc.trans(' ' => '_');
            my $count = +$lc.comb(/ ^^'==' <-[\n=]>* '{{header|' <-[}]>+? '}}==' \h* $$ /);
            %tasks{.<title>} = {'cat' => %cat{$cat}, :$count};
            %tasks{.<title>}<top-n> = (^@top-n).map( {
                ($lc.contains("==\{\{header|{@top-n[$_].lc}}}") or
                 # Deal with 3 part headers - {{header|F_Sharp|F#}}, {{header|C_Sharp|C#}}, etc.
                 $lc.contains("==\{\{header|{@top-n[$_].lc}|")  or
                 # Icon and Unicon are their own special flowers
                 $lc.contains("}}_and_\{\{header|{@top-n[$_].lc}}}==") or
                 # Language1 / Language2 for shared entries (e.g. C / C++)
                 $lc.contains(rx/'}}''_'*'/''_'*'{{header|'$(@top-n[$_].lc)'}}=='/)) ??
                (@places[$_]) !!
                 # Check if the task was omitted
                 $lc.contains("\{\{omit_from|{@top-n[$_].lc}") ?? 'O' !!
                 # The task is neither done or omitted
                 ' '
            } ).join;
            print clear, 1 + $++, ' ', %cat{$cat}, ' ', .<title>;
        })
    }

    print clear;

    note "\nTask information saved to local file: {$hashfile.IO.absolute}";
    $hashfile.IO.spurt(%tasks.&to-json);

}

# Load information from local file
%tasks = $hashfile.IO.e ?? $hashfile.IO.slurp.&from-json !! ( );

@top-n = %counts.sort( {-.value, .key} )[|$which].map: *.key.trans(' ' => '_');

# Convert saved task info to a table
note "\nBuilding table...";
my $count    = +%tasks;
my $taskcnt  = +%tasks.grep: *.value.<cat> eq %cat<Programming_Tasks>;
my $draftcnt = $count - $taskcnt;
my $total    = sum %tasks{*}»<count>;

# Dump table to a file
my $out = open($tablefile, :w)  or die "$!\n";

$out.say: "<pre>{tc $tier.&ord-n} {$per-tier.&card} programming languages by number of task examples completed:";
$out.say: '    ', join ' ', .map( {("{(@places[|$which])[$_]} {@top-n[$_]}").fmt("%-15s")} ) for (^@top-n).batch(5);
$out.say: "</pre>\n\n<div style=\"height:40em;overflow:scroll;\">";

# Add table boilerplate and caption
$out.say:
    '{|class="wikitable sortable"', "\n",
    "|+ As of { DateTime.new(time) } :: Tasks: { $taskcnt } ::<span style=\"background-color:#ffd\"> Draft Tasks:",
    "{ $draftcnt } </span>:: Total Tasks: { $count } :: Total Examples: { $total }\n",
    "!Count!!Task!!{(@places[|$which]).join('!!')}"
;

# Sort tasks by count then add row
for %tasks.sort: { [-.value<count>, .key] } -> $task {
    $out.say:
      ( $task.value<cat> eq 'Draft'
        ?? "|- style=\"background-color: #ffc\"\n"
        !! "|-\n"
      ),
      "| { $task.value<count> }\n",
      ( $task.key ~~ /\d/
        ?? "|data-sort-value=\"{ $task.key.&naturally }\"| [[{uri-escape $task.key}|{$task.key}]]\n"
        !! "| [[{uri-escape $task.key}|{$task.key}]]\n"
      ),
      "|{ $task.value<top-n>.comb[|$which].join('||') }"
}

$out.say( "|}\n</div>" );
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

sub naturally ($a) { $a.lc.subst(/(\d+)/, ->$/ {0~(65+$0.chars).chr~$0},:g) }

sub clear { "\r" ~ ' ' x 116 ~ "\r" }
