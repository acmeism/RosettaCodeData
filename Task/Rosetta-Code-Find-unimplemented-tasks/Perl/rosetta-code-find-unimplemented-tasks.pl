use LWP::UserAgent;

my $ua = LWP::UserAgent->new;
$ua->agent('');

sub enc { join '', map {sprintf '%%%02x', ord} split //, shift }
sub get { $ua->request( HTTP::Request->new( GET => shift))->content }

sub tasks {
    my($category) = shift;
    my $fmt = 'http://www.rosettacode.org/w/api.php?' .
              'action=query&generator=categorymembers&gcmtitle=Category:%s&gcmlimit=500&format=json&rawcontinue=';
    my @tasks;
    my $json = get(sprintf $fmt, $category);
    while (1) {
        push @tasks, $json =~ /"title":"(.+?)"\}/g;
        $json =~ /"gcmcontinue":"(.+?)"\}/ or last;
        $json = get(sprintf $fmt . '&gcmcontinue=%s', $category, enc $1);
    }
    @tasks;
}

my %language = map {$_, 1} tasks shift || 'perl';
$language{$_} or print "$_\n" foreach tasks('Programming_Tasks'), tasks('Draft_Programming_Tasks');
