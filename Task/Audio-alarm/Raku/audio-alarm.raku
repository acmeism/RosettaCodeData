# 20221111 Raku programming solution

loop (my $wait; $wait !~~ Int;) { $wait=prompt('enter seconds to wait: ') }

loop (my $mp3='';!"$mp3.mp3".IO.e;) { $mp3=prompt('enter filename to play: ') }

run '/usr/bin/clear';

sleep($wait);

run '/usr/bin/mpg123', "$mp3.mp3";
