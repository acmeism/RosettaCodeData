# must be evenly padded with white-space$
my $text = q:to/END/;

 @@@@@              @@
 @    @              @     @@@
 @    @              @    @@
 @    @  @@@   @ @@  @    @@
 @@@@@  @   @  @@  @ @    @@@@@
 @      @@@@@  @     @    @@  @@
 @      @      @     @    @@  @@
 @       @@@   @     @@    @@@@

END

say '' for ^5;
for $text.lines -> $_ is copy {
    my @chars = |｢-+ ., ;: '"｣.comb.pick(*) xx *;
    s:g [' '] = @chars.shift;
    print "                              $_  ";
    s:g [('@'+)(.)] = @chars.shift ~ $0;
    .say;
}
say '' for ^5;
