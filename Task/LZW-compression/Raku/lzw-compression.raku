# 20200421 Updated Raku programming solution ; add unicode support

sub compress(Str $uncompressed --> Seq)  {
    my $dict-size = 256;
    my %dictionary = (.chr => .chr for ^$dict-size);

    my $w = "";
    gather {
  for $uncompressed.encode('utf8').list.chrs.comb -> $c {
      my $wc = $w ~ $c;
      if %dictionary{$wc}:exists { $w = $wc }
      else {
    take %dictionary{$w};
    %dictionary{$wc} = +%dictionary;
    $w = $c;
      }
  }

  take %dictionary{$w} if $w.chars;
    }
}

sub decompress(@compressed --> Str) {
    my $dict-size = 256;
    my %dictionary = (.chr => .chr for ^$dict-size);

    my $w = shift @compressed;
    ( Blob.new: flat ( gather {
  take $w;
  for @compressed -> $k {
      my $entry;
      if %dictionary{$k}:exists { take $entry = %dictionary{$k} }
      elsif $k == $dict-size    { take $entry = $w ~ $w.substr(0,1) }
      else                      { die "Bad compressed k: $k" }

      %dictionary{$dict-size++} = $w ~ $entry.substr(0,1);
      $w = $entry;
  }
    }  )».ords ).decode('utf-8')
}

say my @compressed = compress('TOBEORNOTTOBEORTOBEORNOT');
say decompress(@compressed);

@compressed = compress('こんにちは𝒳𝒴𝒵こんにちは𝒳𝒴𝒵こんにちは𝒳𝒴𝒵');
say decompress(@compressed);
