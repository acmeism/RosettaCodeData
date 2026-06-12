use HTTP::UserAgent;
use Gumbo;

my $ua = HTTP::UserAgent.new;
my $taskfile = './RC_tasks.html';

# Get list of Tasks
say "Updating Programming_Tasks list...";
my $page   = "https://rosettacode.org/wiki/Category:Programming_Tasks";
my $html   = $ua.get($page).content;
my $xmldoc = parse-html($html, :TAG<div>, :id<mw-pages>);
my @tasks  = parse-html($xmldoc[0].Str, :TAG<li>).Str.comb( /'/wiki/' <-["]>+ / )».substr(6); #"
my $f      = open("./RC_Programming_Tasks.txt", :w)  or die "$!\n";
note "Writing Programming_Tasks file...";
$f.print( @tasks.join("\n") );
$f.close;

sleep .5;

for 'Programming_Tasks' -> $category
{ # Scrape info from each page.

    note "Loading $category file...";
    note "Retreiving tasks...";
    my @entries = "./RC_{$category}.txt".IO.slurp.lines;

    for @entries -> $title {
        note $title;

        # Get the raw page
        my $html = $ua.get: "https://rosettacode.org/wiki/{$title}";

        # Filter out the actual task description
        $html.content ~~ m|'<div id="mw-content-text" lang="en" dir="ltr" class="mw-content-ltr"><div'
                            .+? 'using any language you may know.</div>' (.+?) '<div id="toc"'|;

        my $task = cleanup $0.Str;

        # save to a file
        my $fh = $taskfile.IO.open :a;

        $fh.put: "<hr>\n     $title\n<hr>\n$task";

        $fh.close;

        sleep 3; # Don't pound the server
    }
}

sub cleanup ( $string ) {
    $string.subst( /^.+ '</div>'/, '' )
}
