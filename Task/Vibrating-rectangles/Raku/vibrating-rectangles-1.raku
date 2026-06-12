# box drawing characters
my %r = :tl<┌>, :h<─>, :tr<┐>, :v<│>, :bl<└>, :br<┘>;

my @colors = « \e[1;31m \e[1;94m \e[1;33m \e[1;35m \e[1;36m \e[1;32m \e[1;34m »;

# color palette
my @c = flat @colors[0] xx 12, @colors[3] xx 12, @colors[2] xx 12;

print "\e[?25l"; # hide the cursor

signal(SIGINT).tap: {
    print "\e[0H\e[0J\e[?25h"; # clean up on exit
    exit;
}

my $rot = 1;

my @vibe;

loop {
    rect($_, 31-$_) for ^15;
    display @vibe;
    @c.=rotate($rot);
    if ++$ %% 30 {
        @c = |@colors.pick(3);
        @c = sort(flat @c xx 12);
        $rot *= -1;
    }
    sleep .1;
}

sub rect ($b, $e) {
    @vibe[$b;$b..$e] = @c[$b % @c]~%r<tl>, |((%r<h>) xx ($e - $b - 1)), %r<tr>~"\e[0m";
    @vibe[$e;$b..$e] = @c[$b % @c]~%r<bl>, |((%r<h>) xx ($e - $b - 1)), %r<br>~"\e[0m";
    ($b ^..^ $e).map: { @vibe[$_;$b] = @vibe[$_;$e] = @c[$b % @c]~%r<v>~"\e[0m" }
}

sub display (@rect) {
    print "\e[0H\e[0J\n\n";
    for @rect -> @row {
        print "\t\t\t";
        print $_ // ' ' for @row;
        print "\n";
    }
}
