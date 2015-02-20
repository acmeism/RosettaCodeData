signal(Signal::SIGINT).tap: {
    note "Took { now - INIT now } seconds.";
    exit;
}

for 0, 1, *+* ... * {
    sleep 0.5;
    .say;
}
