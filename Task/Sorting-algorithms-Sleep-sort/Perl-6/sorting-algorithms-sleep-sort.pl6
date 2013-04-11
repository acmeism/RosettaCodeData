use MuEvent;

for <6 8 1 12 2 14 5 2 1 0> -> $item {
    MuEvent::timer( after => $item, cb => sub { say $item } );
}

MuEvent::run;
