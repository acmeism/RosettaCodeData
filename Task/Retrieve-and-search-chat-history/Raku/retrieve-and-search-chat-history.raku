my $needle = @*ARGS.shift // '';
my @haystack;

# 10 days before today, Zulu time
my $begin = DateTime.new(time).utc.earlier(:10days);
say "         Executed at: ", DateTime.new(time).utc;
say "Begin searching from: $begin";

# Today - 10 days through today
for $begin.Date .. DateTime.now.utc.Date -> $date {

    # connect to server, use a raw socket
    my $http = IO::Socket::INET.new(:host('tclers.tk'), :port(80));

    # request file
    $http.print: "GET /conferences/tcl/{$date}.tcl HTTP/1.0\n\n";

    # retrieve file
    my @page = $http.lines;

    # remove header
    @page.splice(0, 8);

    # concatenate multi-line entries to a single line
    while @page {
        if @page[0].substr(0, 13) ~~ m/^'m '\d\d\d\d'-'\d\d'-'\d\d'T'/ {
            @haystack.push: @page.shift;
        }
        else {
            @haystack.tail ~= '␤' ~ @page.shift;
        }
    }

    # close socket
    $http.close;
}

# ignore times before 10 days ago
@haystack.shift while @haystack[0].substr(2, 22) lt $begin.Str;

# print the first and last line of the haystack
say "First and last lines of the haystack:";
.say for |@haystack[0, *-1];
say "Needle: ", $needle;
say  '-' x 79;

# find and print needle lines
.say if .contains( $needle ) for @haystack;
