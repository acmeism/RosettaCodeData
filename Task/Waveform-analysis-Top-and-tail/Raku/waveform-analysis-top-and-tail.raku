# 20250720 Raku programming solution

#!/usr/bin/env raku

sub read-value($data, $start, $bytes, $endian = LittleEndian) {
   given $bytes {
      when 2  { Blob.new($data[$start .. $start + 1]).read-uint16(0, $endian) }
      when 4  { Blob.new($data[$start .. $start + 3]).read-uint32(0, $endian) }
      default { die "Unsupported byte count: $bytes" }
   }
}

sub write-uint32-bytes($value) {
   buf8.new.write-uint32(0, $value, LittleEndian).list
}

sub get-sample(@frame-data, $offset, $bits-per-sample) {
   given $bits-per-sample {
      when 8  { @frame-data[$offset] - 128 }
      when 16 {
         my $value = (@frame-data[$offset + 1] +< 8) +| @frame-data[$offset];
         $value >= 0x8000 ?? $value - 0x10000 !! $value;
      }
      default { die "Unsupported bit depth: $bits-per-sample" }
   }
}

sub is-frame-silent(@frame-data, $bits-per-sample, $num-channels, $threshold-low, $threshold-high) {
   my $bytes-per-sample = $bits-per-sample div 8;

   for ^$num-channels -> $ch {
      my $sample = get-sample(@frame-data, $ch * $bytes-per-sample, $bits-per-sample);
      return False unless $threshold-low <= $sample <= $threshold-high;
   }
   return True;
}

sub find-data-chunk(@file-content) {
   my @data-bytes = 0x64, 0x61, 0x74, 0x61; # 'data'
   for ^(@file-content.elems - 7) -> $i {
       return $i if @file-content[$i..$i+3] ~~ @data-bytes
   }
   die "No data chunk found";
}

sub MAIN($input-file, $output-file, $threshold-low = -1000, $threshold-high = 1000) {
   say "Processing: $input-file → $output-file";
   say "Thresholds: $threshold-low to $threshold-high";

   # Read and validate file
   my @file-content = slurp($input-file, :bin).list or die "Cannot read: $input-file";
   die "Not a WAV file" unless Blob.new(@file-content[8..11]).decode('ascii') eq 'WAVE';

   # Parse header
   my $sample-rate      = read-value(@file-content, 24, 4);
   my $byte-rate        = read-value(@file-content, 28, 4);
   my $num-channels     = read-value(@file-content, 22, 2);
   my $bits-per-sample  = read-value(@file-content, 34, 2);
   my $bytes-per-sample = $bits-per-sample div 8;
   my $bytes-per-frame  = $num-channels * $bytes-per-sample;

   say "Format: {$sample-rate}Hz, {$bits-per-sample}-bit, {$num-channels} channel(s)";

   # Find audio data
   my $data-chunk-start = find-data-chunk(@file-content);
   my $data-length      = read-value(@file-content, $data-chunk-start + 4, 4);
   my $data-start       = $data-chunk-start + 8;
   my @audio-data = @file-content[$data-start ..^ $data-start + $data-length];
   my $frames     = @audio-data.elems div $bytes-per-frame;

   say "Original: {($data-length / $byte-rate).fmt('%.3f')}s ({$frames} frames)";

   # Find non-silent boundaries
   my ($non-silent-start, $non-silent-end) = (-1, -1);

   for ^$frames -> $frame-idx {
      my $offset = $frame-idx * $bytes-per-frame;
      my @frame-data = @audio-data[$offset .. $offset + $bytes-per-frame - 1];

      unless is-frame-silent(@frame-data, $bits-per-sample, $num-channels, $threshold-low, $threshold-high) {
         $non-silent-start = $offset if $non-silent-start == -1;
         $non-silent-end   = $offset + $bytes-per-frame - 1;
      }
   }

   # Handle completely silent file
   if $non-silent-start == -1 { ($non-silent-start, $non-silent-end) = (0, -1) }

   # Crop audio data
   my @cropped-data = $non-silent-end >= $non-silent-start
                      ?? @audio-data[$non-silent-start .. $non-silent-end]
                      !! ();

   my $new-data-length = @cropped-data.elems;
   say "Cropped : {($new-data-length / $byte-rate).fmt('%.3f')}s ({@cropped-data.elems div $bytes-per-frame} frames)";

   # Build new file
   my @new-header = @file-content[0 .. $data-chunk-start + 3];

   # Update data chunk size
   @new-header[$data-chunk-start + 4 .. $data-chunk-start + 7] = write-uint32-bytes($new-data-length);

   # Update RIFF chunk size
   my $new-file-size = $data-chunk-start + 8 + $new-data-length;
   @new-header[4..7] = write-uint32-bytes($new-file-size - 8);

   # Write output
   my @output-data = @new-header.append(@cropped-data);
   spurt($output-file, Blob.new(@output-data));
   say "Wrote $output-file";
}
