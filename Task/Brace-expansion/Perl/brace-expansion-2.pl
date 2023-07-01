while (my $input = <DATA>) {
    chomp($input);
    print "$input\n";
    print "    $_\n" for brace_expand($input);
    print "\n";
}

__DATA__
~/{Downloads,Pictures}/*.{jpg,gif,png}
It{{em,alic}iz,erat}e{d,}, please.
{,{,gotta have{ ,\, again\, }}more }cowbell!
{}} some }{,{\\{ edge, edge} \,}{ cases, {here} \\\\\}
