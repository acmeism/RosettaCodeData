my $name = $*PROGRAM-NAME;
my $pid = $*PID;

my $lockdir = "/tmp";
my $lockfile = "$lockdir/$name.pid";
my $lockpid = "$lockfile$pid";
my $havelock = False;

END {
    unlink $lockfile if $havelock;
    try unlink $lockpid;
}

my $pidfile = open "$lockpid", :w or die "Can't create $lockpid: $!";
$pidfile.say($pid);
$pidfile.close;

if try link($lockpid, $lockfile) {
    $havelock = True;
}
else {
    shell "kill -CONT `cat $lockfile` || rm $lockfile";
    if try link($lockpid, $lockfile) {
        $havelock = True;
    }
    else {
        die "You can't run right now!";
    }
}
note "Got lock!";
unlink $lockpid;
