FORK:
if ($pid = fork()) {
    # parent code
} elsif (defined($pid)) {
    setsid; # tells apache to let go of this process and let it run solo
    # disconnect ourselves from input, output, and errors
    close(STDOUT);
    close(STDIN);
    close(STDERR);
    # re-open to /dev/null to prevent irrelevant warn messages.
    open(STDOUT, '>/dev/null');
    open(STDIN, '>/dev/null');
    open(STDERR, '>>/home/virtual/logs/err.log');

    # child code

    exit; # important to exit
} elsif($! =~ /emporar/){
    warn '[' . localtime() . "] Failed to Fork - Will try again in 10 seconds.\n";
    sleep(10);
    goto FORK;
} else {
    warn '[' . localtime() . "] Unable to fork - $!";
    exit(0);
}
