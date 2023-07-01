my $command = shift or die "No command supplied\n";
my @output_and_errors = qx/$command 2>&1/ or die "Couldn't execute command\n";
