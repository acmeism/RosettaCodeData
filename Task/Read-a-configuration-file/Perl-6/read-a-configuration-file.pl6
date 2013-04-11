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

    proto token line() {{*}}

    token line:misc  { {} (\S+) { die "Unrecognized word: $0" } }

    token line:sym<comment> { ^^ [ ';' | '#' ] \N* }
    token line:sym<blank>   { ^^ \h* $$ }

    token line:sym<fullname>       {:i fullname»       <rest> { $fullname = $<rest>[0].trim } }
    token line:sym<favouritefruit> {:i favouritefruit» <rest> { $favouritefruit = $<rest>[0].trim } }
    token line:sym<needspeeling>   {:i needspeeling»    <yes> { $needspeeling = defined $<yes>[0] } }
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
    token line:sym<otherfamily>    {:i otherfamily»    <many> { @otherfamily = $<many>[0]».trim} }
    token many { \h*'='? ([ <![,]> \N ]*) ** ',' }
}

MyConfFile.parsefile('file.cfg');

.perl.say for
    :$fullname,
    :$favouritefruit,
    :$needspeeling,
    :$seedsremoved,
    :@otherfamily;
