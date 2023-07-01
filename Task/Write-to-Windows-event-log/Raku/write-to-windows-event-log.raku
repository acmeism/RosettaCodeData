given $*DISTRO {
    when .is-win {
        my $cmd = "eventcreate /T INFORMATION /ID 123 /D \"Bla de bla bla bla\"";
        run($cmd);
    }
    default { # most POSIX environments
        use Log::Syslog::Native;
        my $logger = Log::Syslog::Native.new(facility => Log::Syslog::Native::User);
        $logger.info("[$*PROGRAM-NAME pid=$*PID user=$*USER] Just thought you might like to know.");
    }
}
