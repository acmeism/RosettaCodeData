#!/usr/bin/env perl6

react {
    my %connections;

    whenever IO::Socket::Async.listen('localhost', 4004) -> $conn {
        my $name;

        $conn.print: "Please enter your name: ";

        whenever $conn.Supply.lines -> $message {
            if !$name {
                if %connections{$message} {
                    $conn.print: "Name already taken, choose another one: ";
                }
                else {
                    $name = $message;
                    %connections{$name} = $conn;
                    broadcast "+++ %s arrived +++", $name;
                }
            }
            else {
                broadcast "%s> %s", $name, $message;
            }
            LAST {
                broadcast "--- %s left ---", $name;
                %connections{$name}:delete;
            }
        }
    }

    sub broadcast ($format, $from, *@message) {
        my $text = sprintf $format, $from, |@message;
        say $text;
        for %connections.kv -> $name, $conn {
            $conn.print: "$text\n" if $name ne $from;
        }
    }
}
