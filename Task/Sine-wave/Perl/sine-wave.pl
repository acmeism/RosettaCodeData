use Audio::NoiseGen qw(play sine);

Audio::NoiseGen::init() || die 'No access to sound hardware?';

alarm 5;
play( gen => sine( freq => 440 ) );
