unit sub MAIN ($file-name);
my $file = slurp $file-name;
put $file.=subst(/[^^|['{{' \s*]] '#include' \s+ (\S+) \s* '}}'?/, {run(«$*EXECUTABLE-NAME $*PROGRAM-NAME $0», :out).out.slurp(:close).trim}, :g);
