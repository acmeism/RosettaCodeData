use HTTP::UserAgent;

my $ua = HTTP::UserAgent.new;

$ua.timeout = 10; # seconds

my $server = 'http://api.macvendors.com/';

sub lookup ($mac) {
    my $response = $ua.get: "$server+$mac";
    sleep 1;
    return $response.is-success ?? $response.content !! 'N/A';

    CATCH {             # Normally you would report some information about what
        default { Nil } # went wrong, but the task specifies to ignore errors.
    }
}

for <
BC:5F:F4
FC-A1-3E
10:dd:b1
00:0d:4b
23:45:67
> -> $mac { say lookup $mac }
