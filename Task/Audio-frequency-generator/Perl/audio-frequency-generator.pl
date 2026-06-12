use strict 'vars';
use feature 'say';
use feature 'state';
use Audio::NoiseGen qw(play sine square triangle);
use Term::ReadKey qw(ReadMode ReadLine);

Audio::NoiseGen::init() || die 'No access to sound hardware?';

print "Play [S]ine, s[Q]uare or [T]riangle wave? "; my $ans_freq   = uc(<>);
print "Pick a volume [0-9]";                        my $ans_volume =    <>;
say 'Volume: '. (my $volume = 0.1 + 1 * $ans_volume/10);

ReadMode(3);

my $waveform = $ans_freq eq 'Q' ? 'square' : $ans_freq eq 'T' ? 'triangle' : 'sine';
play ( gen => amp ( amount => $volume, gen => &$waveform( freq => setfreq(440) ) ) );

sub setfreq {
    state $freq;
    say $freq = shift;
    return sub {
        ReadMode(3);
        state $cnt;
        unless ($cnt++ % 1000) {
            my $key = ReadLine(-1);
            my $previous = $freq;
            if    ($key eq "\e[A") { $freq += 10  }
            elsif ($key eq "\e[B") { $freq -= 10  }
            elsif ($key eq "\e[C") { $freq += 100 }
            elsif ($key eq "\e[D") { $freq -= 100 }
            say $freq if $freq != $previous;
        }
        return $freq;
    }
}
