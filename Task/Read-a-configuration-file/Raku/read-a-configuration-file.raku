my $fullname;
my $favouritefruit;
my $needspeeling = False;
my $seedsremoved = False;
my @otherfamily;

grammar ConfFile {
    token TOP {
	:my $*linenum = 0;
	^ <fullline>* [$ || (\N*) { die "Parse failed at $0" } ]
    }

    token fullline {
	<?before .>
	{ ++$*linenum }
	<line>
	[ \n || { die "Parse failed at line $*linenum" } ]
    }

    proto token line() {*}

    token line:misc  { {} (\S+) { die "Unrecognized word: $0" } }

    token line:sym<comment> { ^^ [ ';' | '#' ] \N* }
    token line:sym<blank>   { ^^ \h* $$ }

    token line:sym<fullname>       {:i fullname»       <rest> { $fullname = $<rest>.trim } }
    token line:sym<favouritefruit> {:i favouritefruit» <rest> { $favouritefruit = $<rest>.trim } }
    token line:sym<needspeeling>   {:i needspeeling»    <yes> { $needspeeling = defined $<yes> } }
    token rest { \h* '='? (\N*) }
    token yes { :i \h* '='? \h*
    	[
	    || ([yes|true|1])
	    || [no|false|0]
	    || (<?>)
	] \h*
    }
}

grammar MyConfFile is ConfFile {
    token line:sym<otherfamily>    {:i otherfamily»    <rest> { @otherfamily = $<rest>.split(',')».trim } }
}

MyConfFile.parsefile('file.cfg');

say "fullname: $fullname";
say "favouritefruit: $favouritefruit";
say "needspeeling: $needspeeling";
say "seedsremoved: $seedsremoved";
print "otherfamily: "; say @otherfamily.raku;
