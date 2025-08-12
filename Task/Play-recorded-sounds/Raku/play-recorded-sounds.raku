# 20250723 Raku programming solution

use Audio::Sndfile;
use Audio::PortAudio;

sub play-wavs(Str $filename) {
   my $sf = Audio::Sndfile.new(:filename($filename), :r);
   die "Failed to open $filename" unless $sf;
   my $sample-rate = $sf.samplerate;
   my $channels    = $sf.channels;
   my $pa = Audio::PortAudio.new;
   my $stream = $pa.open-default-stream(
      0, $channels,
      Audio::PortAudio::StreamFormat::Float32,
      $sample-rate, 512
   );
   $stream.start;
   loop {
      my ($buffer, $frames) = $sf.read-float(512, :raw);
      $stream.write($buffer, $frames);
      last if $frames < 512;
   }
   $stream.close;
   $sf.close;
}

sub MAIN(*@files) {
   die "No files provided" unless @files;

   await Promise.allof( @files.map: {  start { .&play-wavs } } )
}
