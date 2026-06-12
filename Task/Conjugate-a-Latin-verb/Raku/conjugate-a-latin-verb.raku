for <amāre dare> -> $infinitive {
    say "\nPresent active indicative conjugation of infinitive $infinitive.";
    my $verb = ($infinitive ~~ /^ (\w+) ['a'|'ā'] 're' $/)[0];
    say $verb ?? (conjugate $verb) !! "Sorry, don't know how to conjugate $infinitive"
}

sub conjugate ($verb) { ($verb X~ <ō ās at āmus ātis ant>).join: "\n" }
