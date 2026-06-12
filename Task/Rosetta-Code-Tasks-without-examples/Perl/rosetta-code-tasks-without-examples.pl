use strict;
use warnings;

use LWP::UserAgent;
my $ua = LWP::UserAgent->new;

# get list of task titles
my $html  = $ua->request( HTTP::Request->new( GET => 'http://rosettacode.org/wiki/Category:Programming_Tasks'))->content;
my @tasks = $html =~ m#<li><a href="/wiki/(.*?)"#g;

# download tasks, and extract task descriptions
for my $title (@tasks) {
    my $html = $ua->request( HTTP::Request->new( GET => "http://rosettacode.org/wiki/$title" ))->content;
    my($task_at_hand) = $html =~ m#using any language you may know.</div>(.*?)<div id="toc"#s;
    print "$title\n$task_at_hand\n\n";
    sleep 10; # so you have time to read each task...
}
