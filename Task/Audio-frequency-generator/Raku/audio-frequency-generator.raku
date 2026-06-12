# 20240130 Raku programming solution

my ($kindS, $kind, $freq, $vol, $dur) = 'sine', |(0 xx *);

while $freq < 40 || $freq > 10000 {
   print "Enter frequency in Hz (40 to 10000) : ";
   $freq = prompt().Int;
}

while $vol < 1 || $vol > 50 {
   print "Enter volume in dB (1 to 50) : ";
   $vol = prompt().Int;
}

while $dur < 2 || $dur > 10 {
   print "Enter duration in seconds (2 to 10) : ";
   $dur = prompt().Int;
}

while $kind < 1 || $kind > 3 {
   print 'Enter kind (1 = Sine, 2 = Square, 3 = Sawtooth) : ';
   given $kind = prompt().Int {
      when $kind == 2 { $kindS = 'square'   }
      when $kind == 3 { $kindS = 'sawtooth' }
   }
}

my @args = "-n", "synth", $dur, $kindS, $freq, "vol", $vol, "dB";
run 'play', @args, :out('/dev/null'), :err('/dev/null');
