my $tape = open "/dev/tape", :w or die "Can't open tape: $!";
$tape.say: "I am a tape file now, or hope to be soon.";
$tape.close;
