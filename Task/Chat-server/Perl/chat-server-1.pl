use 5.010;
use strict;
use warnings;

use threads;
use threads::shared;

use IO::Socket::INET;
use Time::HiRes qw(sleep ualarm);

my $HOST = "localhost";
my $PORT = 4004;

my @open;
my %users : shared;

sub broadcast {
    my ($id, $message) = @_;
    print "$message\n";
    foreach my $i (keys %users) {
        if ($i != $id) {
            $open[$i]->send("$message\n");
        }
    }
}

sub sign_in {
    my ($conn) = @_;

    state $id = 0;

    threads->new(
        sub {
            while (1) {
                $conn->send("Please enter your name: ");
                $conn->recv(my $name, 1024, 0);

                if (defined $name) {
                    $name = unpack('A*', $name);

                    if (exists $users{$name}) {
                        $conn->send("Name entered is already in use.\n");
                    }
                    elsif ($name ne '') {
                        $users{$id} = $name;
                        broadcast($id, "+++ $name arrived +++");
                        last;
                    }
                }
            }
        }
    );

    ++$id;
    push @open, $conn;
}

my $server = IO::Socket::INET->new(
                                   Timeout   => 0,
                                   LocalPort => $PORT,
                                   Proto     => "tcp",
                                   LocalAddr => $HOST,
                                   Blocking  => 0,
                                   Listen    => 1,
                                   Reuse     => 1,
                                  );

local $| = 1;
print "Listening on $HOST:$PORT\n";

while (1) {
    my ($conn) = $server->accept;

    if (defined($conn)) {
        sign_in($conn);
    }

    foreach my $i (keys %users) {

        my $conn = $open[$i];
        my $message;

        eval {
            local $SIG{ALRM} = sub { die "alarm\n" };
            ualarm(500);
            $conn->recv($message, 1024, 0);
            ualarm(0);
        };

        if ($@ eq "alarm\n") {
            next;
        }

        if (defined($message)) {
            if ($message ne '') {
                $message = unpack('A*', $message);
                broadcast($i, "$users{$i}> $message");
            }
            else {
                broadcast($i, "--- $users{$i} leaves ---");
                delete $users{$i};
                undef $open[$i];
            }
        }
    }

    sleep(0.1);
}
