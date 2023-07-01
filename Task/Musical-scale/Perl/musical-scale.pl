use MIDI::Simple;

# setup, 1 quarter note is 0.5 seconds (500,000 microseconds)
set_tempo 500_000;

# C-major scale
n 60; n 62; n 64; n 65; n 67; n 69; n 71; n 72;

write_score 'scale.mid';
