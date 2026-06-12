# 20251201 Raku programming solution

given my $dt = DateTime.new: "0000-01-01" {
   $dt.later( days => .[0]+146097*.[1] ).Date.say for < 0 109573 146096 > X ^6
}
