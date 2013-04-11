use NativeCall;
sub fork() returns Int is native { ... }

if fork() -> $pid {
    print "I am the proud parent of $pid.\n";
}
else {
    print "I am a child.  Have you seen my mommy?\n";
}
