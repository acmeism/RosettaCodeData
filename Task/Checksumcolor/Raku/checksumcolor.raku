unit sub MAIN ($mode = 'ANSI');

if $*OUT.t or $mode eq 'HTML' { # if OUT is a terminal or if in HTML $module

    say '<div style="background-color:black; font-size:125%; font-family: Monaco, monospace;">'
      if $mode eq 'HTML';

    while my $line = get() {
        my $cs  = $line.words[0];
        my $css = $cs ~ $cs.substr(0,5);
        given $mode {
            when 'ANSI' {
                print "\e[48;5;232m";
                .print for $css.comb.rotor(6 => -5)».map({ ($^a, $^b).join })\
                .map( { sprintf "\e[38;2;%d;%d;%dm", |$_».parse-base(16) } ) Z~ $cs.comb;
                say "\e[0m  {$line.words[1..*]}";
            }
            when 'HTML' {
                print "$_\</span>" for $css.comb.rotor(6 => -5)\
                .map( { "<span style=\"color:#{.join};\">" } ) Z~ $cs.comb;
                say " <span style=\"color:#ffffff\"> {$line.words[1..*]}</span>";
                say '<br>';
            }
            default { say $line; }
        }
    }

    say '</div>' if $mode eq 'HTML';
} else { # just pass the unaltered line through
    .say while $_ = get();
}
