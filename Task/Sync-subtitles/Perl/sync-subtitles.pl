# 20241005 Perl programming solution

use strict;
use warnings;
use Time::Piece;
use Time::Seconds;

my @lines = <STDIN>;
for my $seconds (9, -9) {
   print "Original subtitle adjusted by ".sprintf("%+d", $seconds)." seconds.\n";
   for my $line (@lines) {
      if ($line =~ /(\d{2}:\d{2}:\d{2},\d{3}) --> (\d{2}:\d{2}:\d{2},\d{3})/) {
         my $start = adjust_time($1, $seconds);
         my $end   = adjust_time($2, $seconds);
         $line =~ s/\d{2}:\d{2}:\d{2},\d{3} --> \d{2}:\d{2}:\d{2},\d{3}/$start --> $end/;
         print $line
      } else {
         print $line
      }
   }
   print "\n"
}

sub adjust_time {
    my ($time, $seconds) = @_;
    my ($time_str, $milliseconds_str) = split /,/, $time;
    my ($hh, $mm, $ss) = split /:/, $time_str;
    my $t = Time::Piece->strptime("$hh:$mm:$ss", "%H:%M:%S");
    $t += $seconds;
    sprintf("%02d:%02d:%02d,%03d",$t->hour,$t->min,$t->sec,$milliseconds_str);
}
