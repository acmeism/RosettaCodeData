use NativeCall;
sub fork() returns int32 is native { ... }

if fork() -> $pid {
    print "I am the proud parent of $pid.\n";
}
else {
    print "I am a child.  Have you seen my mommy?\n";
}
