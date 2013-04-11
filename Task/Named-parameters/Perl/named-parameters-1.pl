sub funkshun
   {my %h = @_;
    # Print every argument and its value.
    print qq(Argument "$_" has value "$h{$_}".\n)
        foreach sort keys %h;
    # If a 'verbosity' argument was passed in, print its value,
    # whatever that value may be.
    exists $h{verbosity}
        and print "Verbosity specified as $h{verbosity}.\n";
    # Say that safe mode is on if 'safe' is set to a true value.
    # Otherwise, say that it's off.
    print "Safe mode ", ($h{safe} ? 'on' : 'off'), ".\n";}
