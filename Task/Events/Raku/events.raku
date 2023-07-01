note now, " program start";
my $event = Channel.new;

my $todo = start {
    note now, " task start";
    $event.receive;
    note now, " event reset by task";
}

note now, " program sleeping";
sleep 1;
note now, " program signaling event";
$event.send(0);
await $todo;
