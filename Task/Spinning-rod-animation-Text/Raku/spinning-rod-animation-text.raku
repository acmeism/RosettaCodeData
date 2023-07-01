class throbber {
    has @.frames;
    has $.delay is rw = 0;
    has $!index = 0;
    has Bool $.marquee = False;
    method next {
        $!index = ($!index + 1) % +@.frames;
        sleep $.delay if $.delay;
        if $!marquee {
            ("\b" x @.frames) ~ @.frames.rotate($!index).join;
        }
        else {
            "\b" ~ @.frames[$!index];
        }
    }
}

my $rod = throbber.new( :frames(< | / - \ >), :delay(.25) );
print "\e[?25lLong running process...  ";
print $rod.next for ^20;

my $clock = throbber.new( :frames("🕐" .. "🕛") );
print "\r\nSomething else with a delay...   ";
until my $done {
    # do something in a loop;
    sleep 1/12;
    print "\b", $clock.next;
    $done = True if $++ >= 60;
}

my $moon = throbber.new( :frames('🌑🌒🌓🌔🌕🌖🌗🌘'.comb) );
print "\r\nGonna be a long night...   ";
until my $end {
    # do something in a loop;
    sleep 1/8;
    print "\b", $moon.next;
    $end = True if $++ >= 60;
}

my $scroll = throbber.new( :frames('PLEASE STAND BY...      '.comb), :delay(.1), :marquee );
print "\r\nEXPERIENCING TECHNICAL DIFFICULTIES: { $scroll.frames.join }";
print $scroll.next for ^95;

END { print "\e[?25h\n" } # clean up on exit
