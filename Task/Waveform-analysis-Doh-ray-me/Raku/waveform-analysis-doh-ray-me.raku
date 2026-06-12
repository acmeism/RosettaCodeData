# 20200721 Raku programming solution

my \freqs = < 261.6 293.6 329.6 349.2 392.0 440.0 493.9 523.3 >;
my \notes = < Doh Ray Mee Fah Soh Lah Tee doh >;

sub getNote (\freq) {
   my $index = freqs;
   for (0..^$index) { $index = $_ and last if freq ≤ freqs[$_] }
   given $index {
      when 0     { "Doh-" }
      when freqs { "doh+" }
      default    { freqs[$index] - freq ≤ freq - freqs[$index-1]
                       ?? notes[$index] ~ "-" !! notes[$index-1] ~ "+" }
   }
}

my $file = slurp "./notes.wav", :bin or die;

# http://www.topherlee.com/software/pcm-tut-wavformat.html
# https://stackoverflow.com/a/49081648/3386748

my $sampleRate = Blob.new(@$file[24..27]).read-uint32(0,LittleEndian);
# self-ref: [+] @$file[24..27].pairs.map: {$_.value*256**$_.key};
say "Sample Rate    : ", $sampleRate;

my $dataLength = Blob.new(@$file[40..43]).read-uint32(0,LittleEndian);
# self-ref: [+] @$file[40..43].pairs.map: {$_.value*256**$_.key};
my $duration = $dataLength / $sampleRate;
say "Duration       : ", $duration;

my ( $sum, $sampleRateF )  =  ( 0, $sampleRate.Num ) ;
my $nbytes = 20;

say "Bytes examined : ", $nbytes, " per sample";

for @$file[44..*].rotor($sampleRate) -> $data {
   for (1..$nbytes) -> $k {
      my $bf = @$data[$k] / 32;
      $sum += $bf.asin × $sampleRateF / ( 2 × π × $k );
   }
}

my $cav = $sum / ( $duration * $nbytes );
say "Computed average frequency = {$cav.fmt('%.1f')} Hz ({getNote($cav)})";

my $aav = ([+] freqs) / freqs;
say "Actual   average frequency = {$aav.fmt('%.1f')} Hz ({getNote($aav)})";
