# 20240621 Raku programming solution

sub MAIN() {
   my @lines = $*IN.lines;
   for 9, -9 -> $seconds {
      say "Original subtitle adjusted by {$seconds.fmt('%+d')} seconds.";
      for @lines -> $line {
         if $line ~~ /(\d ** 2 ':' \d ** 2 ':' \d ** 2 ',' \d ** 3) ' --> ' (\d ** 2 ':' \d ** 2 ':' \d ** 2 ',' \d ** 3)/ {
            my $start = adjust-time($0.Str, $seconds);
            my $end   = adjust-time($1.Str, $seconds);
            my $adjusted = $line;
            $adjusted ~~ s/\d ** 2 ':' \d ** 2 ':' \d ** 2 ',' \d ** 3 ' --> ' \d ** 2 ':' \d ** 2 ':' \d ** 2 ',' \d ** 3/$start ~ ' --> ' ~ $end/.Str;
            say $adjusted
         } else {
            say $line;
         }
      }
      say()
   }
}

sub adjust-time($time, $seconds) {
   my ($time_str, $milliseconds_str) = $time.split(',');
   my (\hh, \mm, \ss) = $time_str.split(':')>>.Int;
   my $milliseconds = $milliseconds_str.Int;
   my $datetime = DateTime.new(:year,     :month,      :day,
                               :hour(hh), :minute(mm), :second(ss));
   given $datetime .= later(:seconds($seconds)) {
      return sprintf('%02d:%02d:%02d,%03d',.hour,.minute,.second,$milliseconds)
   }
}
